source "/etc/libvirt/hooks/kvm.conf"

if [ -f "$LOCK_FILE" ]; then
    PID=$(cat "$LOCK_FILE")
    if ps -p $PID > /dev/null; then
        kill $PID
        #echo "VM Stop: Sleep inhibitor (PID $PID) removed"
    fi
    rm "$LOCK_FILE"
fi
