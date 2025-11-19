#!/bin/bash

# Configuration
BACKUP_SOURCE="/media/s880"  # Change this to your source folder
BACKUP_DEST="/media/external/backups"  # Change to your external disk path
RETENTION_DAYS=180  # Keep backups for 180 days
BORG_COMPRESSION="lz4"  # Fast compression, you can change to zstd for better ratio
LOG_DIR="$BACKUP_DEST/logs"  # Directory for log files

# Function to setup logging
setup_logging() {
    local subfolder="$1"
    local safe_subfolder="${subfolder//\//_}"
    local timestamp=$(date +%Y%m%d_%H%M%S)
    
    # Create log directory if it doesn't exist
    mkdir -p "$LOG_DIR"
    
    # Define log files
    LOG_FILE="$LOG_DIR/backup_${safe_subfolder}_${timestamp}.log"
    ERROR_LOG_FILE="$LOG_DIR/backup_${safe_subfolder}_${timestamp}_errors.log"
    
    # Create a symlink to the latest log for easy access
    LATEST_LOG="$LOG_DIR/latest_${safe_subfolder}_backup.log"
    
    # Function to log messages
    log() {
        local message="$1"
        local timestamp=$(date '+%Y-%m-%d %H:%M:%S')
        echo "[$timestamp] $message" | tee -a "$LOG_FILE"
    }
    
    # Function to log errors
    log_error() {
        local message="$1"
        local timestamp=$(date '+%Y-%m-%d %H:%M:%S')
        echo "[$timestamp] ERROR: $message" | tee -a "$LOG_FILE" >> "$ERROR_LOG_FILE"
    }
}

# Function to display help
show_help() {
    echo "Usage: $0 [OPTIONS]"
    echo "Borg backup script for subfolder backups"
    echo ""
    echo "Options:"
    echo "  -s, --subfolder SUBFOLDER    Backup the specified subfolder (REQUIRED)"
    echo "  -l, --list-subfolders        List available subfolders in source directory"
    echo "  -h, --help                   Show this help message"
    echo "  --init-repo                  Initialize Borg repository for specified subfolder"
    echo "  --list-archives              List existing backups for specified subfolder"
    echo "  --mount-archive ARCHIVE      Mount specified archive to /tmp/borg-mount"
    echo ""
    echo "Examples:"
    echo "  $0 -s documents             # Backup the 'documents' subfolder"
    echo "  $0 -l                       # List available subfolders"
    echo "  $0 -s documents --init-repo # Initialize repo for documents subfolder"
    echo "  $0 -s documents --list-archives # List backups for documents"
}

# Function to list available subfolders
list_subfolders() {
    if [ ! -d "$BACKUP_SOURCE" ]; then
        echo "Error: Source directory '$BACKUP_SOURCE' does not exist."
        exit 1
    fi
    
    echo "Available subfolders in '$BACKUP_SOURCE':"
    echo "=========================================="
    find "$BACKUP_SOURCE" -maxdepth 1 -type d | while read -r dir; do
        if [ "$dir" != "$BACKUP_SOURCE" ]; then
            relative_path="${dir#$BACKUP_SOURCE/}"
            if [ -n "$relative_path" ]; then
                echo "  $relative_path"
            fi
        fi
    done
}

# Function to get Borg repository path for a subfolder
get_borg_repo() {
    local subfolder="$1"
    # Create a safe repository name by replacing slashes with underscores
    local repo_name="${subfolder//\//_}"
    echo "$BACKUP_DEST/$repo_name"
}

# Function to initialize Borg repository for a subfolder
init_borg_repo() {
    local subfolder="$1"
    local BORG_REPO=$(get_borg_repo "$subfolder")
    
    if [ ! -d "$BORG_REPO" ]; then
        log "Initializing Borg repository for '$subfolder' at $BORG_REPO"
        mkdir -p "$(dirname "$BORG_REPO")"
        if borg init --encryption=none "$BORG_REPO" 2>&1 | tee -a "$LOG_FILE"; then
            log "Borg repository for '$subfolder' initialized successfully."
        else
            log_error "Failed to initialize Borg repository for '$subfolder'."
            exit 1
        fi
    else
        log "Borg repository for '$subfolder' already exists at $BORG_REPO"
    fi
}

# Function to list existing archives for a subfolder
list_archives() {
    local subfolder="$1"
    local BORG_REPO=$(get_borg_repo "$subfolder")
    
    if [ -d "$BORG_REPO" ]; then
        log "Existing Borg archives for '$subfolder':"
        echo "======================================" | tee -a "$LOG_FILE"
        borg list "$BORG_REPO" 2>&1 | tee -a "$LOG_FILE"
    else
        log_error "Borg repository not found for '$subfolder' at $BORG_REPO"
        echo "Run '$0 -s $subfolder --init-repo' to initialize it first." | tee -a "$LOG_FILE"
        exit 1
    fi
}

# Function to mount archive
mount_archive() {
    local subfolder="$1"
    local archive_name="$2"
    local BORG_REPO=$(get_borg_repo "$subfolder")
    local mount_point="/tmp/borg-mount"
    
    if [ ! -d "$BORG_REPO" ]; then
        log_error "Borg repository not found for '$subfolder' at $BORG_REPO"
        exit 1
    fi
    
    mkdir -p "$mount_point"
    log "Mounting archive '$archive_name' for '$subfolder' to $mount_point"
    if borg mount "$BORG_REPO::$archive_name" "$mount_point" 2>&1 | tee -a "$LOG_FILE"; then
        log "Archive mounted successfully at $mount_point"
        echo "Use 'borg umount $mount_point' to unmount when done." | tee -a "$LOG_FILE"
    else
        log_error "Failed to mount archive."
        exit 1
    fi
}

# Parse command line arguments
SUB_FOLDER=""
INIT_REPO=false
LIST_ARCHIVES=false
MOUNT_ARCHIVE=""

while [[ $# -gt 0 ]]; do
    case $1 in
        -s|--subfolder)
            SUB_FOLDER="$2"
            shift
            shift
            ;;
        -l|--list-subfolders)
            list_subfolders
            exit 0
            ;;
        -h|--help)
            show_help
            exit 0
            ;;
        --init-repo)
            INIT_REPO=true
            shift
            ;;
        --list-archives)
            LIST_ARCHIVES=true
            shift
            ;;
        --mount-archive)
            MOUNT_ARCHIVE="$2"
            shift
            shift
            ;;
        *)
            echo "Unknown option: $1"
            show_help
            exit 1
            ;;
    esac
done

# Validate that subfolder is provided for most operations
if [ -z "$SUB_FOLDER" ] && [ "$INIT_REPO" = false ] && [ "$LIST_ARCHIVES" = false ] && [ -z "$MOUNT_ARCHIVE" ]; then
    if [ "$INIT_REPO" = true ] || [ "$LIST_ARCHIVES" = true ] || [ -n "$MOUNT_ARCHIVE" ]; then
        echo "Error: --subfolder is required for this operation."
        show_help
        exit 1
    fi
    echo "Error: --subfolder is required."
    show_help
    exit 1
fi

# Setup logging if we're doing a backup operation
if [ -n "$SUB_FOLDER" ] && [ "$INIT_REPO" = false ] && [ "$LIST_ARCHIVES" = false ] && [ -z "$MOUNT_ARCHIVE" ]; then
    setup_logging "$SUB_FOLDER"
    log "Starting backup process for subfolder: $SUB_FOLDER"
fi

# Handle special operations that require subfolder
if [ "$INIT_REPO" = true ] && [ -n "$SUB_FOLDER" ]; then
    setup_logging "$SUB_FOLDER"
    init_borg_repo "$SUB_FOLDER"
    exit 0
fi

if [ "$LIST_ARCHIVES" = true ] && [ -n "$SUB_FOLDER" ]; then
    setup_logging "$SUB_FOLDER"
    list_archives "$SUB_FOLDER"
    exit 0
fi

if [ -n "$MOUNT_ARCHIVE" ] && [ -n "$SUB_FOLDER" ]; then
    setup_logging "$SUB_FOLDER"
    mount_archive "$SUB_FOLDER" "$MOUNT_ARCHIVE"
    exit 0
fi

# Main backup operation - validate subfolder is provided
if [ -z "$SUB_FOLDER" ]; then
    echo "Error: --subfolder is required for backup operation."
    show_help
    exit 1
fi

# Set paths for backup
SOURCE_PATH="$BACKUP_SOURCE/$SUB_FOLDER"
BACKUP_TIMESTAMP=$(date +%Y%m%d_%H%M%S)
ARCHIVE_NAME="backup-${BACKUP_TIMESTAMP}"
BORG_REPO=$(get_borg_repo "$SUB_FOLDER")

# Create destination directory if it doesn't exist
mkdir -p "$BACKUP_DEST"

# Check if source exists
if [ ! -d "$SOURCE_PATH" ]; then
    log_error "Source path '$SOURCE_PATH' does not exist."
    echo "Use '$0 -l' to see available subfolders." | tee -a "$LOG_FILE"
    exit 1
fi

# Check if external disk is mounted
if [ ! -d "$BACKUP_DEST" ]; then
    log_error "Backup destination not available. Is the external disk mounted?"
    exit 1
fi

# Initialize Borg repository if it doesn't exist
if [ ! -d "$BORG_REPO" ]; then
    log "Borg repository for '$SUB_FOLDER' not found. Initializing..."
    init_borg_repo "$SUB_FOLDER"
fi

# Create backup
log "Starting Borg backup: $(date)"
log "Subfolder: $SUB_FOLDER"
log "Source: $SOURCE_PATH"
log "Archive: $ARCHIVE_NAME"
log "Repository: $BORG_REPO"

# Build Borg command for incremental backup
BORG_CMD=("borg" "create" "--compression" "$BORG_COMPRESSION" "--stats")

# Add filters for better incremental performance
#BORG_CMD+=(--files-cache=mtree,size)
BORG_CMD+=(--filter AME)

# Execute backup - Borg automatically does incremental backup
log "Executing Borg backup command..."
if "${BORG_CMD[@]}" "$BORG_REPO::$ARCHIVE_NAME" "$SOURCE_PATH" 2>&1 | tee -a "$LOG_FILE"; then
    log "Backup completed successfully: $ARCHIVE_NAME"
    
    # Prune old backups for this specific subfolder
    log "Pruning backups older than $RETENTION_DAYS days for '$SUB_FOLDER'..."
    if borg prune --verbose --list --keep-within "${RETENTION_DAYS}d" "$BORG_REPO" 2>&1 | tee -a "$LOG_FILE"; then
        log "Pruning completed successfully"
    else
        log_error "Pruning failed or had warnings"
    fi
    
    # Display repository info
    log "Repository information for '$SUB_FOLDER':"
    if borg info "$BORG_REPO" 2>&1 | tee -a "$LOG_FILE"; then
        log "Repository info retrieved successfully"
    else
        log_error "Failed to get repository info"
    fi
    
    # Create symlink to latest log
    ln -sf "$LOG_FILE" "$LATEST_LOG"
    log "Log file saved: $LOG_FILE"
    if [ -s "$ERROR_LOG_FILE" ]; then
        log "Errors were recorded in: $ERROR_LOG_FILE"
    fi
    
else
    log_error "Backup failed!"
    # Create symlink to latest log even on failure
    ln -sf "$LOG_FILE" "$LATEST_LOG"
    log_error "Check log file for details: $LOG_FILE"
    if [ -s "$ERROR_LOG_FILE" ]; then
        log_error "Error log: $ERROR_LOG_FILE"
    fi
    exit 1
fi

log "Backup process completed: $(date)"
