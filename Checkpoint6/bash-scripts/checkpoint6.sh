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


source ./vm_create.sh "$VM_WC" "$VM_IMG_WC" "$NIC_WC" "$Student_vnet_name" "$Subnet_WC" "WC_NSG_name"
# source ./vm_create.sh "$VM_LR" "$VM_IMG_LR" "$NIC_LR" "$Router_vnet_name" "$Subnet_LR" "LR_NSG_name"
# source ./vm_create.sh "$VM_LR" "$VM_IMG_LR" "$NIC_LR" "$Router_vnet_name" "$Subnet_LR" "LR_NSG_name"
source ./vm_create.sh "$VM_WS" "$VM_IMG_WS" "$NIC_WS" "$Server_vnet_name" "$Subnet_WS" "WS_NSG_name"

