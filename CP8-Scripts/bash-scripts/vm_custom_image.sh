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
echo "Loaded image variabes without error"


if [[ -z $1 ]]; then
    echo
    echo "---------------------------------------------------"
    echo "target_version parameter not provided"
    echo "Usage: ./image_create.sh <target_version>"
    echo "---------------------------------------------------"
    echo
    exit 1
fi

target_version=$1

function windows_vm_from_custom_image () {
vm_name=$1
nic_name=$2
hyperv_gen=$3

base_name=$(echo "$vm_name" | tr '[:upper:]' '[:lower:]')
image_name="$base_name-ver-$target_version"
echo $image_name

image_id=$(az image show -g $RG_NAME --name $image_name -o tsv --query id)
echo $image_id

echo "---------------------------------------------------"
echo "VM: $vm_name from image: $image_name"
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
                --data-disk-delete-option Delete \
                --nics  $nic_name \
                --no-wait
        # if [ $? ]; then echo "Returned Error! Aborting!"; exit 2; fi
    fi
fi
}

echo 
echo "---------------------------------------------------"
echo "Virtual Machines from Custom Images"
echo "---------------------------------------------------"
echo

vm="$VM_WC"
nic_name="$NIC_WC"
hyperv_gen="V2"
windows_vm_from_custom_image $vm $nic_name $hyperv_gen

vm="$VM_WS"
nic_name="$NIC_WS"
windows_vm_from_custom_image $vm $nic_name $hyperv_gen

vm="$VM_LR"
nic_name="$NIC_LR"
windows_vm_from_custom_image $vm $nic_name $hyperv_gen

vm="$VM_LS"
nic_name="$NIC_LS"
windows_vm_from_custom_image $vm $nic_name $hyperv_gen

echo
echo "---------------------------------------------------"
echo "VMs created without error!"
echo "END!"
echo "---------------------------------------------------"
echo


