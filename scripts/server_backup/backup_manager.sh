#!/bin/bash

# Configuration
BACKUP_SOURCE="/media/s880"  # Change this to your source folder
BACKUP_DEST="/media/external/backups"  # Change to your external disk path
RETENTION_DAYS=180  # Keep backups for 180 days
BORG_COMPRESSION="lz4"  # Fast compression, you can change to zstd for better ratio

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
        echo "Initializing Borg repository for '$subfolder' at $BORG_REPO"
        mkdir -p "$(dirname "$BORG_REPO")"
        borg init --encryption=none "$BORG_REPO"
        if [ $? -eq 0 ]; then
            echo "Borg repository for '$subfolder' initialized successfully."
        else
            echo "Failed to initialize Borg repository for '$subfolder'."
            exit 1
        fi
    else
        echo "Borg repository for '$subfolder' already exists at $BORG_REPO"
    fi
}

# Function to list existing archives for a subfolder
list_archives() {
    local subfolder="$1"
    local BORG_REPO=$(get_borg_repo "$subfolder")
    
    if [ -d "$BORG_REPO" ]; then
        echo "Existing Borg archives for '$subfolder':"
        echo "======================================"
        borg list "$BORG_REPO"
    else
        echo "Borg repository not found for '$subfolder' at $BORG_REPO"
        echo "Run '$0 -s $subfolder --init-repo' to initialize it first."
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
        echo "Borg repository not found for '$subfolder' at $BORG_REPO"
        exit 1
    fi
    
    mkdir -p "$mount_point"
    echo "Mounting archive '$archive_name' for '$subfolder' to $mount_point"
    borg mount "$BORG_REPO::$archive_name" "$mount_point"
    if [ $? -eq 0 ]; then
        echo "Archive mounted successfully at $mount_point"
        echo "Use 'borg umount $mount_point' to unmount when done."
    else
        echo "Failed to mount archive."
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

# Handle special operations that require subfolder
if [ "$INIT_REPO" = true ] && [ -n "$SUB_FOLDER" ]; then
    init_borg_repo "$SUB_FOLDER"
    exit 0
fi

if [ "$LIST_ARCHIVES" = true ] && [ -n "$SUB_FOLDER" ]; then
    list_archives "$SUB_FOLDER"
    exit 0
fi

if [ -n "$MOUNT_ARCHIVE" ] && [ -n "$SUB_FOLDER" ]; then
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
ARCHIVE_NAME="backup-$(date +%Y%m%d_%H%M%S)"
BORG_REPO=$(get_borg_repo "$SUB_FOLDER")

# Create destination directory if it doesn't exist
mkdir -p "$BACKUP_DEST"

# Check if source exists
if [ ! -d "$SOURCE_PATH" ]; then
    echo "Error: Source path '$SOURCE_PATH' does not exist."
    echo "Use '$0 -l' to see available subfolders."
    exit 1
fi

# Check if external disk is mounted
if [ ! -d "$BACKUP_DEST" ]; then
    echo "Error: Backup destination not available. Is the external disk mounted?"
    exit 1
fi

# Initialize Borg repository if it doesn't exist
if [ ! -d "$BORG_REPO" ]; then
    echo "Borg repository for '$SUB_FOLDER' not found. Initializing..."
    init_borg_repo "$SUB_FOLDER"
fi

# Create backup
echo "Starting Borg backup: $(date)"
echo "Subfolder: $SUB_FOLDER"
echo "Source: $SOURCE_PATH"
echo "Archive: $ARCHIVE_NAME"
echo "Repository: $BORG_REPO"

# Build Borg command for incremental backup
# Borg is inherently incremental - it only stores changes from previous backups
BORG_CMD=("borg" "create" "--compression" "$BORG_COMPRESSION" "--stats" "--progress")

# Add filters for better incremental performance (optional)
#BORG_CMD+=(--files-cache=mtree,size)
BORG_CMD+=(--filter AME)

# Execute backup - Borg automatically does incremental backup
"${BORG_CMD[@]}" "$BORG_REPO::$ARCHIVE_NAME" "$SOURCE_PATH"

# Check if backup was successful
if [ $? -eq 0 ]; then
    echo "Backup completed successfully: $ARCHIVE_NAME"
    
    # Prune old backups for this specific subfolder
    echo "Pruning backups older than $RETENTION_DAYS days for '$SUB_FOLDER'..."
    borg prune --verbose --list --keep-within "${RETENTION_DAYS}d" "$BORG_REPO"
    
    # Display repository info
    echo "Repository information for '$SUB_FOLDER':"
    borg info "$BORG_REPO"
    
    # Show space savings from deduplication
    echo ""
    echo "Space savings from incremental backup and deduplication:"
    borg info "$BORG_REPO" | grep -E "(All archives|This archive|Deduplication)"
else
    echo "Backup failed!"
    exit 1
fi

echo "Backup process completed: $(date)"
