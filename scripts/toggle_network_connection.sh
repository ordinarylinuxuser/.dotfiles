#!/bin/bash

# Check if at least one bridge name is provided
if [ $# -eq 0 ]; then
    echo "Usage: $0 <bridge-name-1> [bridge-name-2] ..."
    exit 1
fi

# Loop through all provided bridge names
for BRIDGE in "$@"; do
    # Verify bridge exists
    if ! nmcli connection show "$BRIDGE" &>/dev/null; then
        echo "Error: Bridge '$BRIDGE' not found. Skipping."
        continue
    fi

    # Check current state
    ACTIVE_STATE=$(nmcli -g GENERAL.STATE device show "$BRIDGE" 2>/dev/null)
    
    # Toggle state based on current status
    if [[ "$ACTIVE_STATE" == *"connected"* ]]; then
        nmcli connection down "$BRIDGE"
        echo "Bridge '$BRIDGE' deactivated."
    else
        nmcli connection up "$BRIDGE"
        echo "Bridge '$BRIDGE' activated."
    fi
done
