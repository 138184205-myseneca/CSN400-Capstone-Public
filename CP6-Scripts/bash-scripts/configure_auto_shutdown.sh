echo "Loading variables:"
echo "network_config.sh"
source ./network_config.sh
echo "vm_config.sh"
source ./vm_config.sh
echo "Loaded variabes without error"

echo "======================================================================"
echo
echo "vm auto-shutdown uses UTC, must convert to Eastern Standard Time (EST)"
echo "This script will configure: 12:00 midnight EST"
echo
echo "======================================================================"

shutdown_time="0500"

for vm_name in "${vm_list[@]}"
do
echo "---------------------------------------------------------------------"
echo "Do you want to Create auto-shutdown schedule for: $vm_name? (yes/no)"
echo "---------------------------------------------------------------------"
read -r answer
if [[ "$answer" == "yes" ]]; then
    az vm auto-shutdown -g $RG_NAME -n $vm_name --time $shutdown_time
fi
done