read -p "Client: " client
VIVA_RDPW_LOCATION="VivaVm.rdpw"
OTR_RDPW_LOCATION="OTRVm.rdpw"
FREERDP="xfreerdp"
if grep -q '^ID=arch$' /etc/os-release; then
    FREERDP="xfreerdp3" #for arch use the xfreerdp3 cli
fi

if [ "$client" = "viva" ]; then
    $FREERDP $VIVA_RDPW_LOCATION /gateway:type:arm /sec:aad /floatbar +auto-reconnect +dynamic-resolution
fi

if [ "$client" = "otr" ]; then
    read -p "User:" user
    read -s -p "Password:" pass
    $FREERDP $OTR_RDPW_LOCATION /gateway:type:arm /u:$user /p:$pass /d:peregrine.local /sec:tls /cert:ignore /floatbar +auto-reconnect +dynamic-resolution
fi

if [ "$client" = "win11" ]; then
    read -p "User:" user
    read -s -p "Password:" pass

    VM_NAME="win11"  # Replace with your virtual machine's name
    LIBVIRT_DEFAULT_URI="--connect qemu:///system"

    # Get the current state of the VM using virsh
    state=$(virsh $LIBVIRT_DEFAULT_URI domstate "$VM_NAME" 2>/dev/null)

    # Check if the state does not include "running"
    if [[ "$state" != *"running"* ]]; then
        echo
        echo "VM '$VM_NAME' is not running. Starting it..."
        virsh $LIBVIRT_DEFAULT_URI start "$VM_NAME"
     
        # Wait until the VM state indicates it's running
        while [[ $(virsh $LIBVIRT_DEFAULT_URI domstate "$VM_NAME" 2>/dev/null) != *"running"* ]]; do
            sleep 30
        done
    fi

    $FREERDP /v:192.168.3.35 /u:$user /p:$pass /monitors:1 /audio-mode:0 /audio:sys:alsa /mic:sys:alsa /floatbar /cert:ignore /f +dynamic-resolution +auto-reconnect /auto-reconnect-max-retries:10 -compression +video
fi
