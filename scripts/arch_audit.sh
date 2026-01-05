#!/bin/bash

# Setup
BACKUP_ROOT="$HOME/arch_audit_$(date +%Y%m%d)"
mkdir -p "$BACKUP_ROOT"/{hardware,packages,vms,kde_for_dotfiles}

echo "Starting System Audit & Backup to $BACKUP_ROOT..."

# --- 1. HARDWARE & MOUNTS (New) ---
echo "1. Dumping Filesystem Table and Block Info..."
# Copy the actual fstab
cp /etc/fstab "$BACKUP_ROOT/hardware/fstab_backup"
# Dump block device info (UUIDs are critical for fstab reconstruction)
lsblk -o NAME,FSTYPE,LABEL,UUID,MOUNTPOINT,SIZE > "$BACKUP_ROOT/hardware/disk_layout.txt"
# Optional: crypttab if you use encryption
[ -f /etc/crypttab ] && cp /etc/crypttab "$BACKUP_ROOT/hardware/crypttab_backup"

# --- 2. PACKAGES ---
echo "2. Exporting package lists..."
pacman -Qqe > "$BACKUP_ROOT/packages/pacman_list.txt"
pacman -Qqem > "$BACKUP_ROOT/packages/aur_list.txt"

# --- 3. VIRTUAL MACHINES ---
echo "3. Exporting KVM/Virt-Manager XMLs..."
# Ensure libvirtd is reachable
if systemctl is-active --quiet libvirtd; then
    for vm in $(virsh list --all --name); do
        if [ -n "$vm" ]; then
            virsh dumpxml "$vm" > "$BACKUP_ROOT/vms/$vm.xml"
            echo "   > Saved config for: $vm"
        fi
    done
else
    echo "   ! Warning: libvirtd is not running. Cannot dump VM configs."
fi

# --- 4. KWIN & PLASMA (For your Dotfiles) ---
echo "4. Staging KDE Configs for your Dotfiles..."
CONFIG_DIR="$HOME/.config"
TARGET_DIR="$BACKUP_ROOT/kde_for_dotfiles"

# List of critical KDE files
files=(
    "kwinrc"
    "plasmarc"
    "kdeglobals"
    "kglobalshortcutsrc"
    "khotkeysrc"
    "plasma-org.kde.plasma.desktop-appletsrc"
)

for file in "${files[@]}"; do
    if [ -f "$CONFIG_DIR/$file" ]; then
        cp "$CONFIG_DIR/$file" "$TARGET_DIR/"
        echo "   > Staged $file"
    fi
done

# KWin Scripts (Custom window tiling scripts, etc.)
if [ -d "$HOME/.local/share/kwin" ]; then
    cp -r "$HOME/.local/share/kwin" "$TARGET_DIR/kwin_scripts_local_share"
    echo "   > Staged local KWin scripts"
fi

echo "--------------------------------------------------------"
echo "✅ Audit Complete."
echo "1. Check '$BACKUP_ROOT/hardware/disk_layout.txt' for your UUIDs."
echo "2. Check files from '$BACKUP_ROOT/kde_for_dotfiles' for your KDE configs."
echo "3. Manually backup VM disk images (.qcow2) if needed."
echo "--------------------------------------------------------"
