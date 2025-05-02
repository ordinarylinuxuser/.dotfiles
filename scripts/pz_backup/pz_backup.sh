#!/bin/bash

# Backup script for Project Zomboid saves with ZIP compression
# Configurable variables
SAVE_DIR="$HOME/Zomboid/Saves"     # Default save location
BACKUP_DIR="/data/Zomboid_Backups" # Where to store backups
MAX_BACKUPS=50                     # Maximum number of backups to keep
LOG_FILE="$BACKUP_DIR/backup.log"
COMPRESSION_LEVEL=9 # 1 (fastest) to 9 (best compression)

# Create backup directory if it doesn't exist
mkdir -p "$BACKUP_DIR"

touch "$LOG_FILE" # Ensure log file exists

create_backup() {
    # Generate timestamp for backup file
    TIMESTAMP=$(date +"%Y-%m-%d_%H-%M-%S")
    BACKUP_FILE="$BACKUP_DIR/pz_backup_$TIMESTAMP.tar.gz"

    # Create compressed backup
    echo "Creating compressed backup at $BACKUP_FILE" | tee -a "$LOG_FILE"

    # Show progress if pv is installed
    if command -v pv >/dev/null; then
        tar cf - -C "$SAVE_DIR" . | pv -s $(du -sb "$SAVE_DIR" | awk '{print $1}') | gzip -$COMPRESSION_LEVEL >"$BACKUP_FILE"
    else
        echo "Compressing files (install pv for progress display)..." | tee -a "$LOG_FILE"
        tar czf "$BACKUP_FILE" -C "$SAVE_DIR" .
    fi

    # Clean up old backups
    while [ $(ls -1 $BACKUP_DIR/pz_backup_*.tar.gz 2>/dev/null | wc -l) -gt $MAX_BACKUPS ]; do
        OLDEST_BACKUP=$(ls -1t $BACKUP_DIR/pz_backup_*.tar.gz | tail -n 1)
        echo "Removing old backup: $OLDEST_BACKUP" | tee -a "$LOG_FILE"
        rm -f "$OLDEST_BACKUP"
    done

    echo "Backup completed at $(date)" | tee -a "$LOG_FILE"
    echo "Archive size: $(du -h "$BACKUP_FILE" | cut -f1)" | tee -a "$LOG_FILE"
    echo "---------------------------" | tee -a "$LOG_FILE"
}

create_backup
