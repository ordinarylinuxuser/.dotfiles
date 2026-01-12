
source "/etc/libvirt/hooks/kvm.conf"

systemctl --quiet is-active "$LOCK_UNIT"

# Check if already running to avoid errors
if [ $? -ne 0 ]; then
     systemd-run --unit="$LOCK_UNIT" \
                --description="Prevent sleep for VM 'win11'" \
                --service-type=simple \
                systemd-inhibit --what=sleep \
                                --who="Libvirt-Hook" \
                                --why="VM 'win11' is running" \
                                --mode=block \
                                sleep infinity
fi