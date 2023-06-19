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
echo "image_config.sh"
source ./image_config.sh
echo "Loaded image variabes without error"


if [[ -z $1 ]]; then
    echo
    echo "---------------------------------------------------"
    echo "latest_version parameter not provided"
    echo "Usage: ./image_create.sh <latest_version>"
    echo "---------------------------------------------------"
    echo
    exit 1
fi

latest_version=$1
osDisk_id=$(az vm get-instance-view -g $RG_NAME -n WC-99 -o tsv --query storageProfile.osDisk.managedDisk.id)

az image create --name "WS-99-image-1.0.1" \
                --resource-group $RG_NAME \
                --source $osDisk_id \
                --data-disk-caching None \
                --hyper-v-generation V2 \
                --location $LOCATION  \
                --os-disk-caching None \
                --os-type Windows \
                --storage-sku StandardSSD_LRS


function windows_vm_from_custom_image () {
vm_name=$1
image_id=$2
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
                --image  $image_id \
                --size  $VM_SIZE \
                --storage-sku $OS_DISK_SKU \
                --data-disk-delete-option Delete \
                --nics  $nic_name 
                # --no-wait
        # if [ $? ]; then echo "Returned Error! Aborting!"; exit 2; fi
    fi
fi
}


function linux_vm_from_custom_image () {
vm_name=$1
image_id=$2
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
                --image  $image_id \
                --size  $VM_SIZE \
                --storage-sku $OS_DISK_SKU \
                --data-disk-delete-option Delete \
                --nics  $nic_name

        # if [ $? ]; then echo "Returned Error! Aborting!"; exit 2; fi
    fi
fi
}


echo 
echo "---------------------------------------------------"
echo "Virtual Machines from Custom Images"
echo "---------------------------------------------------"
echo


# vm=$VM_WC
# image_def="IMG-def-$vm"
# image_ver=$latest_version
# image_id=$(az sig image-version show  -g $RG_NAME -r $sig_name \
#         --gallery-image-definition $image_def \
#         --gallery-image-version $image_ver -o tsv --query id)
# echo "Image ID: $image_id"
# nic=$NIC_WC
# windows_vm_from_custom_image WC-99-2 $image_id $nic

# vm=$VM_WS
# image_def="IMG-def-$vm"
# image_ver=$latest_version
# image_id=$(az sig image-version show  -g $RG_NAME -r $sig_name \
#         --gallery-image-definition $image_def \
#         --gallery-image-version $image_ver -o tsv --query id)
# nic=$NIC_WS
# windows_vm_from_custom_image $vm $image_id $nic

# vm=$VM_LR
# image_def="IMG-def-$vm"
# image_ver=$latest_version
# image_id=$(az sig image-version show  -g $RG_NAME -r $sig_name \
#         --gallery-image-definition $image_def \
#         --gallery-image-version $image_ver -o tsv --query id)
# nic=$NIC_LR
# linux_vm_create $vm $image_id $nic

# vm=$VM_LS
# image_def="IMG-def-$vm"
# image_ver=$latest_version
# image_id=$(az sig image-version show  -g $RG_NAME -r $sig_name \
#         --gallery-image-definition $image_def \
#         --gallery-image-version $image_ver -o tsv --query id)
# nic=$NIC_LR
# linux_vm_create $vm $image_id $nic


echo
echo "---------------------------------------------------"
echo "VMs created without error!"
echo "END!"
echo "---------------------------------------------------"
echo


