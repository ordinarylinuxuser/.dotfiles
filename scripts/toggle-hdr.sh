#!/usr/bin/env bash

# Usage: ./toggle-hdr.sh [OUTPUT-NAME]
# Example: ./toggle-hdr.sh DP-1

# Get kscreen-doctor output and strip all invisible ANSI color codes
KSCREEN_OUT=$(kscreen-doctor -o | sed 's/\x1b\[[0-9;]*m//g')

# Check if an output argument was provided
if [ -z "$1" ]; then
    echo "Error: Please specify a monitor output."
    echo "Available connected outputs:"
    # Now that colors are stripped, the awk command will work perfectly
    echo "$KSCREEN_OUT" | awk '/^Output:/{out=$3} /connected/{print out}'
    exit 1
fi

OUTPUT="$1"

# Extract HDR status from the clean output
HDR_STATUS=$(echo "$KSCREEN_OUT" | grep -i "$OUTPUT" -A 20 | grep -i "HDR:" | head -n 1 | awk '{print $2}')

# Toggle logic
if [[ "${HDR_STATUS,,}" == "enabled" ]]; then
    echo "HDR is ENABLED on $OUTPUT. Disabling..."
    kscreen-doctor output."$OUTPUT".hdr.disable output."$OUTPUT".wcg.disable
    
    # Wait 2 seconds for the monitor to finish switching to SDR
    sleep 2
    
    # Restore Brightness to 100
    ddcutil --display 2 setvcp 10 100
    
elif [[ "${HDR_STATUS,,}" == "disabled" ]]; then
    echo "HDR is DISABLED on $OUTPUT. Enabling..."
    kscreen-doctor output."$OUTPUT".hdr.enable output."$OUTPUT".wcg.enable
else
    echo "Could not determine HDR status for '$OUTPUT'."
    echo "Ensure you typed the output name correctly (e.g., DP-1 or HDMI-A-2)."
    exit 1
fi
