#!/bin/bash


#delete Un-assigned NIC
unattachedNicsIds=$(az network nic list --query '[?virtualMachine==`null`].[id]' -o tsv)
for id in ${unattachedNicsIds[@]}
do
       echo "Deleting unattached NIC with Id: "$id
       az network nic delete --ids $id
       echo "Deleted unattached NIC with Id: "$id
done

#delete Empty NSG
noNICnsg=$(az network nsg list --query '[?networkInterfaces=='null'].[id]' -o tsv)
for nsgid in ${noNICnsg[@]}
do
                echo "Deleting nsg with Id: "$nsgid
                az network nsg delete --ids $nsgid
                echo "Deleted nsg with Id: "$nsgid

done

# delete Un-used Public-IP
unusedpublicIP=$(az network public-ip list --query '[?ipConfiguration=='null'].[id]' -o tsv)
for publicipId in ${unusedpublicIP[@]}
do
				echo "Deleting unused public-IP with Id: "$publicipId
                az network public-ip delete --ids $publicipId
                echo "Deleted unused public-IP with Id: "$nsgid
				
done
#unused vnet
unusedvnet=$( az network vnet list --query '[?ipConfigurations=='null'].[id]' -o tsv)
for vnet in ${unusedvnet[@]}
do
				echo "Deleting unused vnet with Id: "$vnet
                az network vnet delete --ids $vnet
                echo "Deleted unused vnet with Id: "$vnet

done

#delete unattached disks
unattachedDisk=$(az disk list --query '[?managedBy=='null'].[id]' -o tsv | grep brooklyn*)
for disk in ${unattachedDisk[@]}
do
				echo "Deleting unused disk with Id: "$disk
                az disk delete --ids $disk
                echo "Deleted unused disk with Id: "$disk

done


#delete empty Resource-Group
for i in `az group list -o tsv --query [].name`; 
do
if [ "$(az resource list -g $i -o tsv)" ]; 
then echo "$i is not empty"; 
else az group delete -n $i -y --no-wait; 
fi; 
done 