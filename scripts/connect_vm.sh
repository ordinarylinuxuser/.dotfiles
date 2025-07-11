source ~/.dotfiles-private/.connect_vm.env
source ~/.dotfiles-private/.ip.env

read -p "Client: " client

FREERDP="xfreerdp"
IS_RDP=0
if grep -q '^ID=arch$' /etc/os-release; then
    FREERDP="xfreerdp3" #for arch use the xfreerdp3 cli
    IS_RDP=1
fi

connect_vm_rdp() {
    local VM_NAME=$1
    local IP=$2
    local USER=$3
    local PASS=$4
    local LIBVIRT_DEFAULT_URI="--connect qemu:///system"

    # Get the current state of the VM using virsh
    local state=$(virsh $LIBVIRT_DEFAULT_URI domstate "$VM_NAME" 2>/dev/null)

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

    if [ "$IS_RDP" -eq 1 ]; then
        $FREERDP /v:${IP} /u:${USER} /p:${PASS} /audio-mode:0 /monitors:0 /audio:sys:alsa /mic:sys:alsa /floatbar /cert:ignore /f +dynamic-resolution +auto-reconnect /auto-reconnect-max-retries:10 -compression +video
    else
        # Now connect to the VM using virt-viewer
        virt-viewer $LIBVIRT_DEFAULT_URI --attach --full-screen "$VM_NAME"
    fi

    return 0
}

if [ "$client" = "viva" ]; then
    $FREERDP $VIVA_RDPW_LOCATION /gateway:type:arm /sec:aad /floatbar /f +auto-reconnect +dynamic-resolution
fi

if [ "$client" = "otr" ]; then
    $FREERDP $OTR_RDPW_LOCATION /gateway:type:arm /u:$OTR_USER /p:$OTR_PASS /d:$OTR_DOMAIN /sec:tls /cert:ignore /floatbar +auto-reconnect +dynamic-resolution /f
fi

if [ "$client" = "win11" ]; then
    connect_vm_rdp $WIN11_VM_NAME $IP_ARCH_VM $WIN11_USER $WIN11_PASS
fi

if [ "$client" = "archlinux" ]; then
    connect_vm_rdp $ARCH_VM_NAME $IP_WIN11_VM $ARCH_USER $ARCH_PASS
fi
