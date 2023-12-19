#!/bin/bash

# Ask user to choose the type of VM to create
echo "Select the type of VM to create:"
echo "1. Windows 10"
echo "2. Windows Server 2019"
read -p "Enter your choice (1 or 2): " VM_CHOICE

if [ "$VM_CHOICE" == "1" ]; then
    VM_NAME="Windows10VM"
    ISO_PATH="/home/rcode/Downloads/Windows10.iso" # Windows 10 ISO path
    OS_TYPE="Windows10_64"
elif [ "$VM_CHOICE" == "2" ]; then
    VM_NAME="WindowsServer2019VM"
    ISO_PATH="/home/rcode/Downloads/UnServ2019Install.iso" # Windows Server 2019 ISO path
    OS_TYPE="Windows2019_64"
else
    echo "Invalid choice. Exiting."
    exit 1
fi

# Ask for VM Name
read -p "Enter a name for your VM: " VM_NAME

# Remaining Variables
VM_DIR="/home/rcode/VirtualBox VMs"
HDD_SIZE=50000 # Size in MB, 50 GB here
RAM_SIZE=2048 # Size in MB, 2 GB here
CPU_COUNT=2

# Create VM
VBoxManage createvm --name "$VM_NAME" --ostype "$OS_TYPE" --register --basefolder "$VM_DIR"

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

# Configure network to connect to internal network 'intnet007' on adapter 1
VBoxManage modifyvm "$VM_NAME" --nic1 intnet --intnet1 intnet007

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
