#!/bin/bash

# --- CONFIGURATION ---
BACKUP_ROOT="$HOME/arch_backup_$(date +%Y%m%d)"
CURRENT_USER="$USER"
CURRENT_GROUP=$(id -gn)

echo "🚀 Starting Backup as user: $CURRENT_USER"
echo "📂 Backup Location: $BACKUP_ROOT"

# 0. Sudo Keep-Alive
# This asks for your password ONCE at the start and keeps the token alive
# so you don't have to type it for every single command.
echo "🔒 This script needs sudo access to read system configs (/etc, libvirt)."
sudo -v
while true; do sudo -n true; sleep 60; kill -0 "$$" || exit; done 2>/dev/null &

# Create Directory Structure
mkdir -p "$BACKUP_ROOT"/{boot_configs,modprobe,hooks,vms,hardware,packages,ssh_keys,kde_for_dotfiles,looking_glass}

# --- 1. SSH KEYS (No Sudo Needed) ---
echo "🔑 1. Backing up SSH Keys..."
if [ -d "$HOME/.ssh" ]; then
    cp -r "$HOME/.ssh" "$BACKUP_ROOT/ssh_keys/"
    echo "   ✅ Backed up .ssh directory"
else
    echo "   ⚠️ No .ssh directory found."
fi

# --- 2. BOOT, GRUB & KERNEL (Sudo Required) ---
echo "🐧 2. Backing up Boot & Kernel Params..."

# We use 'sudo cat' redirected to a user-owned file. 
# This preserves the content but ensures YOU own the backup file, not root.
sudo cat /etc/default/grub > "$BACKUP_ROOT/boot_configs/grub_default"
sudo cat /etc/mkinitcpio.conf > "$BACKUP_ROOT/boot_configs/mkinitcpio.conf"

if [ -d "/etc/modprobe.d" ]; then
    # For directories, we must cp then fix ownership
    sudo cp -r /etc/modprobe.d/* "$BACKUP_ROOT/modprobe/" 2>/dev/null
    sudo chown -R "$CURRENT_USER:$CURRENT_GROUP" "$BACKUP_ROOT/modprobe/"
fi

# Looking Glass (Sudo Required)
if [ -f "/etc/tmpfiles.d/10-looking-glass.conf" ]; then
    sudo cat "/etc/tmpfiles.d/10-looking-glass.conf" > "$BACKUP_ROOT/looking_glass/10-looking-glass.conf"
    echo "   ✅ Backed up Looking Glass tmpfile"
fi

# --- 3. LIBVIRT & VMS (Sudo Required) ---
echo "🖥️  3. Exporting VM Configs & Hooks..."

# Hooks (Sudo Required)
if [ -d "/etc/libvirt/hooks" ]; then
    sudo cp -r /etc/libvirt/hooks/* "$BACKUP_ROOT/hooks/" 2>/dev/null
    sudo chown -R "$CURRENT_USER:$CURRENT_GROUP" "$BACKUP_ROOT/hooks/"
    echo "   ✅ Backed up Libvirt hooks"
fi

# VM XML Dumps (Sudo Required for system-wide QEMU)
# We use sudo virsh to see system VMs. 
# The output is redirected > so the file is owned by you.
for vm in $(sudo virsh list --all --name); do
    if [ -n "$vm" ]; then
        sudo virsh dumpxml "$vm" > "$BACKUP_ROOT/vms/$vm.xml"
        echo "   ✅ Saved XML: $vm"
    fi
done

# --- 4. HARDWARE MAP (Mixed) ---
echo "💾 4. Dumping Filesystem info..."
sudo cat /etc/fstab > "$BACKUP_ROOT/hardware/fstab_backup"
# lsblk doesn't need sudo
lsblk -o NAME,FSTYPE,LABEL,UUID,MOUNTPOINT,SIZE > "$BACKUP_ROOT/hardware/disk_layout.txt"

# --- 5. PACKAGES (No Sudo Needed) ---
echo "📦 5. Exporting Package Lists..."
# Querying the database is safe as user
pacman -Qqe > "$BACKUP_ROOT/packages/pacman_list.txt"
pacman -Qqem > "$BACKUP_ROOT/packages/aur_list.txt"

# --- 6. KDE CONFIGS (No Sudo Needed) ---
echo "🎨 6. Staging KDE Configs..."
KDE_TARGET="$BACKUP_ROOT/kde_for_dotfiles"
KDE_SOURCE="$HOME/.config"

files=(
    "kwinrc"
    "plasmarc"
    "kdeglobals"
    "kglobalshortcutsrc"
    "khotkeysrc"
    "plasma-org.kde.plasma.desktop-appletsrc"
)

for file in "${files[@]}"; do
    if [ -f "$KDE_SOURCE/$file" ]; then
        cp "$KDE_SOURCE/$file" "$KDE_TARGET/"
    fi
done

# Local Share KWin Scripts
if [ -d "$HOME/.local/share/kwin" ]; then
     cp -r "$HOME/.local/share/kwin" "$KDE_TARGET/kwin_local_share"
fi

echo "--------------------------------------------------------"
echo "✅ Backup Complete!"
echo "📂 Files are located in: $BACKUP_ROOT"
echo "--------------------------------------------------------"
