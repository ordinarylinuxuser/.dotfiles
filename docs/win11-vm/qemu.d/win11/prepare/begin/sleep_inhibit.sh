source "/etc/libvirt/hooks/kvm.conf"


# We start 'sleep infinity' wrapped in systemd-inhibit in the background
systemd-inhibit --what=sleep \
                --who="Libvirt-Hook" \
                --why="VM 'win11' is running" \
                --mode=block \
                sleep infinity &

# Save the PID of the inhibitor so we can kill it later
echo $! > "$LOCK_FILE"
