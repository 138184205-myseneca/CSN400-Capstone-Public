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
echo "Delting Visrtual Machines"
echo "---------------------------------------------------"
echo
for vm_name in "${vm_list[@]}"
do
echo "---------------------------------------------------"
echo "Check if exist: $vm_name"
echo "---------------------------------------------------"
if [[ $(az vm list -g $RG_NAME -o tsv --query "[?name=='$vm_name']") ]]
then
    echo "exists!"
    echo "Deleteing VM: $vm_name"
    az vm delete -g $RG_NAME --name $vm_name --no-wait
fi
done