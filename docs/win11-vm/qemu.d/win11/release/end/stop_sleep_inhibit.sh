
source "/etc/libvirt/hooks/kvm.conf"

systemctl --quiet is-active "$LOCK_UNIT"

if [ $? -eq 0 ]; then
    systemctl stop "$LOCK_UNIT"
fi

