source ~/.dotfiles-private/.connect_vm.env

read -p "Client: " client

FREERDP="xfreerdp"
if grep -q '^ID=arch$' /etc/os-release; then
    FREERDP="xfreerdp3" #for arch use the xfreerdp3 cli
fi

if [ "$client" = "viva" ]; then
    $FREERDP $VIVA_RDPW_LOCATION /gateway:type:arm /sec:aad /floatbar /f +auto-reconnect +dynamic-resolution
fi

if [ "$client" = "otr" ]; then
    $FREERDP $OTR_RDPW_LOCATION /gateway:type:arm /u:$OTR_USER /p:$OTR_PASS /d:$OTR_DOMAIN /sec:tls /cert:ignore /floatbar +auto-reconnect +dynamic-resolution /f
fi

if [ "$client" = "win11" ]; then
    VM_NAME=$WIN11_VM_NAME # Replace with your virtual machine's name
    LIBVIRT_DEFAULT_URI="--connect qemu:///system"

    # Get the current state of the VM using virsh
    state=$(virsh $LIBVIRT_DEFAULT_URI domstate "$VM_NAME" 2>/dev/null)

    # Check if the state does not include "running"
    if [[ "$state" != *"running"* ]]; then
        echo
        echo "VM '$VM_NAME' is not running. Starting it..."
        virsh $LIBVIRT_DEFAULT_URI start "$VM_NAME"
        
        echo "Waiting 30 seconds for vm to start up"
        sleep 30

        # Wait until the VM state indicates it's running
        while [[ $(virsh $LIBVIRT_DEFAULT_URI domstate "$VM_NAME" 2>/dev/null) != *"running"* ]]; do
            echo "Waiting 30 seconds for vm to start up"
            sleep 30
        done
    fi

    $FREERDP /v:${WIN11_VM_IP} /u:${WIN11_USER} /p:${WIN11_PASS} /monitors:1 /audio-mode:0 /audio:sys:alsa /mic:sys:alsa /floatbar /cert:ignore /f +dynamic-resolution +auto-reconnect /auto-reconnect-max-retries:10 -compression +video
fi
