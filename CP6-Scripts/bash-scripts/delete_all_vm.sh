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
    osDisk_id=$(az vm get-instance-view -g $RG_NAME -n $vm_name -o tsv --query storageProfile.osDisk.managedDisk.id)
    echo "osDisk_id: $osDisk_id"
    echo "Deleteing VM: $vm_name"
    az vm delete -g $RG_NAME --name $vm_name --yes
    az disk delete --ids $osDisk_id --yes
fi
done

for nic_name in "${nic_list[@]}"
do
echo "---------------------------------------------------"
echo "Check if exist: $nic_name"
echo "---------------------------------------------------"
if [[ $(az network nic list -g $RG_NAME -o tsv --query "[?name=='$nic_name']") ]]
then
    echo "exists!"
    echo "Deleteing NIC: $nic_name"
    az netwrok nic delete -g $RG_NAME --name $nic_name
fi
done