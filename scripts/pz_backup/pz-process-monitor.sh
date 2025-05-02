#!/bin/bash
# Process monitoring script
while true; do
    if pgrep -x "ProjectZomboid6" >/dev/null; then
        if [ ! -f /tmp/pz-running ]; then
            $HOME/scripts/pz_backup/pz_backup.sh
            touch /tmp/pz-running
        fi
    else
        rm -f /tmp/pz-running 2>/dev/null
    fi
    sleep 30
done
#
