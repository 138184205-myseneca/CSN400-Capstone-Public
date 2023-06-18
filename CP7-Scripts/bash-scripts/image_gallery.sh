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

echo 
echo "---------------------------------------------------"
echo "Shared Instance Gallery (SIG): $sig_name"
echo "---------------------------------------------------"

echo "Check if it already exists ---"
if [[ $(az sig list -g $RG_NAME -o tsv --query "[?name=='$sig_name']") ]]
then
    echo "exists!"
    az sig show -g $RG_NAME --gallery-name $sig_name --query id 
else
    echo "doesn't exist!"
    echo "Do you want to create VM SIG: $sig_name? (yes/no)"
    read -r answer
    if [[ "$answer" == "yes" ]]; then

        az sig create --gallery-name $sig_name \
            -g $RG_NAME \
            --location $LOCATION 
         
        # if [ $? ]; then echo "Returned Error! Aborting!"; exit 2; fi

        echo "SIG Created!"
        echo "SIG List"
        az sig list -g $RG_NAME --out table
    fi
fi

function sig_image_definition_create () {
image_def=$1
image_offer=$2
image_pub=$3
os_type=$4

image_sku="Standard"
os_state="specialized"

echo 
echo "---------------------------------------------------"
echo "Shared Image Gallery  - Image Definition: $image_def"
echo "---------------------------------------------------"

echo "Check if it already exists ---"
if [[ $(az sig image-definition list -g $RG_NAME -r $sig_name -o tsv --query "[?name=='$image_def']") ]]
then
    echo "exists!"
    az sig image-definition show -g $RG_NAME -r $sig_name --gallery-image-definition $image_def --query id 
else
    echo "doesn't exist!"
    echo "Do you want to create sig image definition: $image_def? (yes/no)"
    read -r answer
    if [[ "$answer" == "yes" ]]; then

        az sig image-definition create \
            -g $RG_NAME \
            --gallery-name $sig_name \
            --location $LOCATION \
            --gallery-image-definition $image_def \
            --publisher $image_pub \
            --offer $image_offer  \
            --sku $image_sku \
            --os-type $os_type \
            --os-state $os_state
         
        # if [ $? ]; then echo "Returned Error! Aborting!"; exit 2; fi

        echo "Iamge Defitnitio Created!"
        az sig image-definition show -g $RG_NAME -r $sig_name --gallery-image-definition $image_def --query id 
    fi
fi

}


echo 
echo "---------------------------------------------------"
echo "Shared Image Gallery - Image Definitions"
echo "---------------------------------------------------"
echo

os_type="Windows"
vm=$VM_WC
sig_image_definition_create "IMG-def-$vm" "$vm-Offer" "CSN400-Publisher-$vm" "$os_type" 
vm=$VM_WS
sig_image_definition_create "IMG-def-$vm" "$vm-Offer" "CSN400-Publisher-$vm" "$os_type" 

os_type="Linux"
vm=$VM_LR
sig_image_definition_create "IMG-def-$vm" "$vm-Offer" "CSN400-Publisher-$vm" "$os_type" 
vm=$VM_LS
sig_image_definition_create "IMG-def-$vm" "$vm-Offer" "CSN400-Publisher-$vm" "$os_type" 

echo "Iamge Definition List"
az sig image-definition list -g $RG_NAME -r $sig_name --out table

echo
echo "---------------------------------------------------"
echo "Image Definitions created without error!"
echo "END!"
echo "---------------------------------------------------"
echo