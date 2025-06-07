#!/bin/bash

# Check for minimum arguments
if [ $# -lt 2 ]; then
    echo "Usage: $0 <up|down> <network-name-1> [network-name-2] ..."
    exit 1
fi

ACTION="$1"
shift

# Validate action
if [[ "$ACTION" != "up" && "$ACTION" != "down" ]]; then
    echo "Error: First parameter must be 'up' or 'down'"
    exit 1
fi

# Loop through all network names
for NETWORK in "$@"; do
    # Verify network exists
    if ! nmcli connection show "$NETWORK" &>/dev/null; then
        echo "Error: Network '$NETWORK' not found. Skipping."
        continue
    fi

    # Get current state
    STATE=$(nmcli -g GENERAL.STATE device show "$NETWORK" 2>/dev/null)
    
    # Process action
    case "$ACTION" in
        up)
            if [[ "$STATE" == *"connected"* ]]; then
                echo "Network '$NETWORK' is already active."
            else
                if nmcli connection up "$NETWORK"; then
                    echo "Network '$NETWORK' activated."
                else
                    echo "Failed to activate '$NETWORK'."
                fi
            fi
            ;;
        down)
            if [[ "$STATE" != *"connected"* ]]; then
                echo "Network '$NETWORK' is already inactive."
            else
                if nmcli connection down "$NETWORK"; then
                    echo "Network '$NETWORK' deactivated."
                else
                    echo "Failed to deactivate '$NETWORK'."
                fi
            fi
            ;;
    esac
done
