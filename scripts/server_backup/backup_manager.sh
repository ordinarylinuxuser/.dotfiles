#!/bin/bash

# Configuration
BACKUP_SOURCE="/media/s880"  # Change this to your source folder
BACKUP_DEST="/media/external/backups"  # Change to your external disk path
RETENTION_DAYS=180  # Keep backups for 30 days
EXCLUDE_FILE=""

# Function to display help
show_help() {
    echo "Usage: $0 [OPTIONS]"
    echo "Backup script with subfolder support"
    echo ""
    echo "Options:"
    echo "  -s, --subfolder SUBFOLDER    Backup only the specified subfolder"
    echo "  -l, --list-subfolders        List available subfolders in source directory"
    echo "  -h, --help                   Show this help message"
    echo ""
    echo "Examples:"
    echo "  $0                          # Backup entire source directory"
    echo "  $0 -s documents             # Backup only the 'documents' subfolder"
    echo "  $0 -l                       # List available subfolders"
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

# Parse command line arguments
SUB_FOLDER=""
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
        *)
            echo "Unknown option: $1"
            show_help
            exit 1
            ;;
    esac
done

# Set backup source based on parameters
if [ -n "$SUB_FOLDER" ]; then
    SOURCE_PATH="$BACKUP_SOURCE/$SUB_FOLDER"
    BACKUP_NAME="backup_${SUB_FOLDER//\//_}_$(date +%Y%m%d_%H%M%S)"
else
    SOURCE_PATH="$BACKUP_SOURCE"
    BACKUP_NAME="full_backup_$(date +%Y%m%d_%H%M%S)"
fi

# Create destination directory if it doesn't exist
mkdir -p "$BACKUP_DEST"

# Check if source exists
if [ ! -d "$SOURCE_PATH" ]; then
    echo "Error: Source path '$SOURCE_PATH' does not exist."
    if [ -n "$SUB_FOLDER" ]; then
        echo "Use '$0 -l' to see available subfolders."
    fi
    exit 1
fi

# Check if external disk is mounted
if [ ! -d "$BACKUP_DEST" ]; then
    echo "Error: Backup destination not available. Is the external disk mounted?"
    exit 1
fi

# Create backup
echo "Starting backup: $(date)"
if [ -n "$SUB_FOLDER" ]; then
    echo "Mode: Subfolder backup ('$SUB_FOLDER')"
else
    echo "Mode: Full backup"
fi
echo "Source: $SOURCE_PATH"
echo "Destination: $BACKUP_DEST/$BACKUP_NAME.zip"

# Create zip backup with exclusions
if [ -f "$EXCLUDE_FILE" ]; then
    echo "Using exclusion file: $EXCLUDE_FILE"
    # Change to parent directory to maintain proper folder structure in zip
    cd "$(dirname "$SOURCE_PATH")" || exit 1
    zip -r "$BACKUP_DEST/$BACKUP_NAME.zip" "$(basename "$SOURCE_PATH")" -x@"$EXCLUDE_FILE"
else
    echo "No exclusion file found at $EXCLUDE_FILE"
    cd "$(dirname "$SOURCE_PATH")" || exit 1
    zip -r "$BACKUP_DEST/$BACKUP_NAME.zip" "$(basename "$SOURCE_PATH")"
fi

# Check if zip was successful
if [ $? -eq 0 ]; then
    echo "Backup completed successfully: $BACKUP_NAME.zip"
    
    # Create appropriate symlink
    if [ -n "$SUB_FOLDER" ]; then
        SYMLINK_NAME="latest_${SUB_FOLDER//\//_}_backup.zip"
    else
        SYMLINK_NAME="latest_full_backup.zip"
    fi
    ln -sf "$BACKUP_DEST/$BACKUP_NAME.zip" "$BACKUP_DEST/$SYMLINK_NAME"
    echo "Created symlink: $SYMLINK_NAME"
    
    # Clean up old backups
    if [ -n "$SUB_FOLDER" ]; then
        # Clean only backups for this subfolder
        PATTERN="backup_${SUB_FOLDER//\//_}_*.zip"
    else
        # Clean full backups
        PATTERN="full_backup_*.zip"
    fi
    
    find "$BACKUP_DEST" -name "$PATTERN" -mtime +$RETENTION_DAYS -delete
    echo "Cleaned up backups older than $RETENTION_DAYS days"
else
    echo "Backup failed!"
    exit 1
fi

echo "Backup process completed: $(date)"
