echo
echo
echo "---------------------------------------------------"
echo "---------------------------------------------------"
echo 
echo "    ____  ___                __    __               "
echo "    |     |__   |\ |  |_|   |  |  |  |              "   
echo "    |___   __|  | \|    |   |__|  |__|              " 
echo
echo "---------------------------------------------------"
echo "---------------------------------------------------"
echo 

echo "Loading variables:"
echo "network_config.sh"
source ./network_config.sh
echo "vm_config.sh"
source ./vm_config.sh
echo "Loaded variabes without error"

echo 
echo "---------------------------------------------------"
echo "Netwrok Interface Cards"
echo "---------------------------------------------------"
echo

source ./nic_create.sh "$NIC_WC" "$Student_vnet_name" "$Subnet_WC" "$WC_NSG_name"
source ./nic_create.sh "$NIC_LR" "$Router_vnet_name" "$Subnet_LR" "$LR_NSG_name"
source ./nic_create.sh "$NIC_WS" "$Server_vnet_name" "$Subnet_WS" "$WS_NSG_name"
source ./nic_create.sh "$NIC_LS" "$Server_vnet_name" "$Subnet_LS" "$LS_NSG_name"

echo 
echo "---------------------------------------------------"
echo "Virtual Machines"
echo "---------------------------------------------------"
echo

source ./windows_vm_create.sh "$VM_WC" "$VM_IMG_WC" "$NIC_WC"
source ./windows_vm_create.sh "$VM_WS" "$VM_IMG_WS" "$NIC_WS"
source ./linux_vm_create.sh "$VM_LR" "$VM_IMG_LR" "$NIC_LR"
source ./linux_vm_create.sh "$VM_LS" "$VM_IMG_LS" "$NIC_LS"

echo
echo "---------------------------------------------------"
echo "NIC & VMs created without error!"
echo "END!"
echo "---------------------------------------------------"
echo

