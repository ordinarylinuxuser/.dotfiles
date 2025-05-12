#!/usr/bin/env bash

SAVE_DIR="$HOME/Zomboid/Saves"     # Default save location
BACKUP_DIR="/data/Zomboid_Backups" # Where to store backups

# Project Zomboid Interactive Restore Script
RESTORE_LOG="$BACKUP_DIR/restore.log"
TIMESTAMP=$(date +"%Y-%m-%d_%H-%M-%S")

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

error() {
    echo -e "${RED}[ERROR]${NC} $1" >&2
    exit 1
}

list_backups() {
    echo -e "\n${YELLOW}Available Backups:${NC}"
    declare -a backups
    mapfile -t backups < <(ls -1t "$BACKUP_DIR"/pz_backup_*.tar.gz 2>/dev/null)

    if [[ ${#backups[@]} -eq 0 ]]; then
        error "No backups found in $BACKUP_DIR"
    fi

    for i in "${!backups[@]}"; do
        printf "%2d) %s\n" $((i + 1)) "$(basename "${backups[$i]}")"
    done
}

restore_backup() {
    local backup_file=$1
    local temp_dir=$(mktemp -d)

    echo -e "\n${YELLOW}Restoring from $backup_file...${NC}"

    # Create restore point
    local restore_point="$BACKUP_DIR/restore_point_$TIMESTAMP.tar.gz"
    echo "Creating restore point: $restore_point"
    tar czf "$restore_point" -C "$SAVE_DIR" . || error "Failed to create restore point"

    # Clear save directory
    rm -rf "$SAVE_DIR/*" || error "Failed to clear save directory"
    echo "Cleared save directory: $SAVE_DIR"

    # Extract backup
    tar xzf "$backup_file" -C "$SAVE_DIR" || error "Failed to extract backup"

    echo -e "${GREEN}Restore completed successfully!${NC}"
    echo "$TIMESTAMP: Restored from $backup_file" >>"$RESTORE_LOG"
}

interactive_restore() {
    clear
    echo -e "${YELLOW}=== Project Zomboid Save Restorer ===${NC}"
    list_backups

    declare -a backups
    mapfile -t backups < <(ls -1t "$BACKUP_DIR"/pz_backup_*.tar.gz)

    while true; do
        echo -ne "\nEnter backup number [1-${#backups[@]}, 'l' to refresh, or 'q' to quit: "
        read -r choice

        case $choice in
        [1-9]*)
            if ((choice >= 1 && choice <= ${#backups[@]})); then
                selected="${backups[$((choice - 1))]}"
                echo -e "\nSelected: ${YELLOW}$(basename "$selected")${NC}"
                read -p "Confirm restore? (y/N): " confirm
                [[ "$confirm" =~ [yY] ]] && restore_backup "$selected"
                return
            else
                echo -e "${RED}Invalid selection${NC}"
            fi
            ;;
        l | L)
            list_backups
            ;;
        q | Q)
            echo "Exiting..."
            exit 0
            ;;
        *)
            echo -e "${RED}Invalid input${NC}"
            ;;
        esac
    done
}

auto_restore() {
    latest_backup=$(ls -1t "$BACKUP_DIR"/pz_backup_*.tar.gz | head -n1)
    echo -e "${YELLOW}Restoring latest backup: ${GREEN}$(basename "$latest_backup")${NC}"
    restore_backup "$latest_backup"
}

# Main execution
if [[ ! -d "$BACKUP_DIR" ]]; then
    error "Backup directory $BACKUP_DIR not found"
fi

case $1 in
-a | --autorestore)
    auto_restore
    ;;
-t | --test)
    echo -e "${YELLOW}Dry-run mode:${NC}"
    tar tzf "$(ls -1t "$BACKUP_DIR"/pz_backup_*.tar.gz | head -n1)"
    ;;
-h | --help)
    echo "Usage: $0 [option]"
    echo "Options:"
    echo "  -a --autorestore  Automatically restore the latest backup"
    echo "  -t, --test         Show contents of latest backup"
    echo "  -h, --help         Show this help"
    echo "  No arguments       Start interactive restore"
    exit 0
    ;;
*)
    interactive_restore
    ;;
esac
