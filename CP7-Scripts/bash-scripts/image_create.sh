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
source ./image_config.sh
echo "Loaded image variabes without error"

latest_version=$1

function custom_image_create () {
vm_name=$1
image_name=$2
nic_name=$3

vm_name=$1
image_def=$2
image_ver=$3

osDisk_id=$(az vm get-instance-view -g $RG_NAME -n $vm_name -o tsv --query storageProfile.osDisk.managedDisk.id)

echo 
echo "---------------------------------------------------"
echo "Image Version $image_ver for vm: $vm_name"
echo "---------------------------------------------------"

echo "Check if it already exists ---"
if [[ $(az sig image-version list -g $RG_NAME -r $sig_name --gallery-image-definition $image_def -o tsv --query "[?name=='$image_ver']") ]]
then
    echo "exists!"
    az sig image-version show -g $RG_NAME -r $sig_name --gallery-image-definition $image_def --gallery-image-version $image_ver --query id 
else
    echo "doesn't exist!"
    echo "Do you want to create sig image version: $image_def? (yes/no)"
    read -r answer
    if [[ "$answer" == "yes" ]]; then
        az sig image-version create \
            --resource-group $RG_NAME \
            --gallery-name $sig_name \
            --location $LOCATION \
            --gallery-image-definition $image_def \
            --gallery-image-version $image_ver \
            --replica-count 1 \
            --os-snapshot $osDisk_id \
            --data-disk-delete-option Delete \
            &> /dev/null
            # if [ $? ]; then echo "Returned Error! Aborting!"; exit 2; fi

        echo "Iamge Version Created!"
        echo "Iamge Version List"
        az sig image-version list -g $RG_NAME -r $sig_name --gallery-image-definition $image_def --out table
    fi
fi

}

# az vm create -g $RG_NAME \
#     --name $vm \
#     --image $imageid \
#     --specialized

echo 
echo "---------------------------------------------------"
echo "Shared Image Gallery - Image Version"
echo "---------------------------------------------------"
echo

os_type="Windows"
vm=$VM_WC
custom_image_create "$vm" "IMG-def-$vm" "$latest_version"
vm=$VM_WS
custom_image_create "$vm" "IMG-def-$vm" "$latest_version" 

os_type="Linux"
vm=$VM_LR
custom_image_create "$vm" "IMG-def-$vm" "$latest_version"
vm=$VM_LS
custom_image_create "$vm" "IMG-def-$vm" "$latest_version"


echo
echo "---------------------------------------------------"
echo "Image version created without error!"
echo "END!"
echo "---------------------------------------------------"
echo