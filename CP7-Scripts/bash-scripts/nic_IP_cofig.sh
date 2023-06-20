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


echo "forwarding enable ... "
az network nic update --name  $NIC_LR  \
                    --resource-group $RG_NAME \
                    --ip-forwarding true 
                    # 2>/dev/null