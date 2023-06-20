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
echo "Netwrok Security Groups"
echo "---------------------------------------------------"
echo
echo "Do you want to create Netwrok Security Groups? (yes/no)"
read -r answer
if [[ "$answer" == "yes" ]] 
then
    for item in "${NSG_list[@]}"
    do
        echo "Creating NSG: $item ---"
        az network nsg create -g $RG_NAME --name $item --location $LOCATION
    done
    echo "Netwrok Security groups created!"
    az network nsg list -g $RG_NAME --out table 
fi

echo
echo "---------------------------------------------------"
echo "Network Security Groups created without error!"
echo "END!"
echo "---------------------------------------------------"
echo
