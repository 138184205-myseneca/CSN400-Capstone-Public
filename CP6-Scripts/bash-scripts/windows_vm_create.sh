echo "Loading variables:"
echo "network_config.sh"
source ./network_config.sh
echo "vm_config.sh"
source ./vm_config.sh
echo "Loaded variabes without error"

vm_name=$1
image_name=$2
nic_name=$3

echo "---------------------------------------------------"
echo "VM: $vm_name"
echo "---------------------------------------------------"
echo "Check if it already exists ---"
if [[ $(az vm list -g $RG_NAME -o tsv --query "[?name=='$vm_name']") ]]
then
    echo "exists!"
    az vm show -g $RG_NAME --name $vm_name --query id 
else
    echo "doesn't exist!"
    echo "Do you want to create VM: $vm_name? (yes/no)"
    read -r answer
    if [[ "$answer" == "yes" ]]; then

        az vm create --name $vm_name -g $RG_NAME  \
                --location $LOCATION \
                --admin-password $ADMIN_PW --admin-username $USER_NAME \
                --image  $image_name \
                --size  $VM_SIZE \
                --storage-sku $OS_DISK_SKU \
                --nics  $nic_name \
                --no-wait
                # --  generate-ssh-keys 
    fi
fi

