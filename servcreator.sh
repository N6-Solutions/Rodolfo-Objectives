#!/bin/bash

# Prompt for VM Name
read -p "Enter the name for the Windows Server VM: " VM_NAME

# Remaining Variables
ISO_PATH="/home/rcode/Downloads/wserver2019.iso"
VM_DIR="/home/rcode/VirtualBox VMs"
HDD_SIZE=50000 # Size in MB, 50 GB here
RAM_SIZE=2048 # Size in MB, 2 GB here
CPU_COUNT=2

# Create VM
VBoxManage createvm --name "$VM_NAME" --ostype "Windows2019_64" --register --basefolder "$VM_DIR"

# Set memory and CPUs
VBoxManage modifyvm "$VM_NAME" --ioapic on
VBoxManage modifyvm "$VM_NAME" --memory $RAM_SIZE --cpus $CPU_COUNT

# Create a hard drive
VBoxManage createhd --filename "$VM_DIR/$VM_NAME/$VM_NAME.vdi" --size $HDD_SIZE

# Attach the hard drive and DVD drive
VBoxManage storagectl "$VM_NAME" --name "SATA Controller" --add sata --controller IntelAHCI
VBoxManage storageattach "$VM_NAME" --storagectl "SATA Controller" --port 0 --device 0 --type hdd --medium "$VM_DIR/$VM_NAME/$VM_NAME.vdi"
VBoxManage storagectl "$VM_NAME" --name "IDE Controller" --add ide
VBoxManage storageattach "$VM_NAME" --storagectl "IDE Controller" --port 0 --device 0 --type dvddrive --medium "$ISO_PATH"

# Configure network
VBoxManage modifyvm "$VM_NAME" --nic1 nat

# Start the VM with a GUI
VBoxManage startvm "$VM_NAME"

echo "VM $VM_NAME started successfully"

# Prompt to Delete the VM
read -p "Do you want to delete the VM you just created? (Y/N): " DELETE_VM

if [[ $DELETE_VM =~ ^[Yy]$ ]]
then
    VBoxManage controlvm "$VM_NAME" poweroff
    sleep 5
    VBoxManage unregistervm "$VM_NAME" --delete
    echo "VM $VM_NAME deleted successfully."
else
    echo "VM $VM_NAME not deleted."
fi
