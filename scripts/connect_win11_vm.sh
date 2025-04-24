#!/bin/bash

VM_NAME="win11"  # Replace with your virtual machine's name
LIBVIRT_DEFAULT_URI="--connect qemu:///system"

# Get the current state of the VM using virsh
state=$(virsh $LIBVIRT_DEFAULT_URI domstate "$VM_NAME" 2>/dev/null)

# Check if the state does not include "running"
if [[ "$state" != *"running"* ]]; then
    echo "VM '$VM_NAME' is not running. Starting it..."
    virsh $LIBVIRT_DEFAULT_URI start "$VM_NAME"
 
    # Wait until the VM state indicates it's running
    while [[ $(virsh $LIBVIRT_DEFAULT_URI domstate "$VM_NAME" 2>/dev/null) != *"running"* ]]; do
        sleep 2
    done
fi

# Now connect to the VM using virt-viewer
virt-viewer $LIBVIRT_DEFAULT_URI --attach --full-screen "$VM_NAME"
