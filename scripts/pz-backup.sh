#!/bin/bash

# Backup script for Project Zomboid saves with ZIP compression
# Configurable variables
# SAVE_DIR="$HOME/Zomboid/Saves"     # Default save location
# BACKUP_DIR="/data/Zomboid_Backups" # Where to store backups
# MAX_BACKUPS=50                     # Maximum number of backups to keep
# LOG_FILE="$BACKUP_DIR/backup.log"
# COMPRESSION_LEVEL=9 # 1 (fastest) to 9 (best compression)
# TAG="manual"        # Tag for backup type

# Put all the variables in a separate file
# Load environment variables from the private file
source ~/.dotfiles-private/.zomboid.env

# Create backup directory if it doesn't exist
mkdir -p "$BACKUP_DIR"

touch "$LOG_FILE" # Ensure log file exists

case "$1" in
--timer)
    TAG="timer" # Use timer tag for backup
    ;;
--game-init)
    TAG="game-init" # Use game initialization tag for backup
    ;;
*)
    TAG="manual" # Default to manual backup
    ;;
esac
create_backup() {
    # Generate timestamp for backup file
    TIMESTAMP=$(date +"%Y-%m-%d_%H-%M-%S")
    BACKUP_FILE="${BACKUP_DIR}/pz_backup_${TAG}_${TIMESTAMP}.tar.gz"

    # Create compressed backup
    echo "Creating compressed backup at $BACKUP_FILE" | tee -a "$LOG_FILE"

    echo "Compressing files ..." | tee -a "$LOG_FILE"
    tar czf "$BACKUP_FILE" -C "$SAVE_DIR" .

    # Clean up old backups
    # while [ $(ls -1 $BACKUP_DIR/pz_backup_*_*.tar.gz 2>/dev/null | wc -l) -gt $MAX_BACKUPS ]; do
    #     OLDEST_BACKUP=$(ls -1t $BACKUP_DIR/pz_backup_*_*.tar.gz | tail -n 1)
    #     echo "Removing old backup: $OLDEST_BACKUP" | tee -a "$LOG_FILE"
    #     rm -f "$OLDEST_BACKUP"
    # done

    echo "Backup completed at $(date)" | tee -a "$LOG_FILE"
    echo "Archive size: $(du -h "$BACKUP_FILE" | cut -f1)" | tee -a "$LOG_FILE"
    echo "---------------------------" | tee -a "$LOG_FILE"
}

create_backup
