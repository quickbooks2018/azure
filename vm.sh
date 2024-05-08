#!/bin/bash

# Set the resource group from the list
export RG=$(az group list --output json | jq -r '.[0].name')
echo "Using Resource Group: $RG"

# Path for the SSH key
export SSH_KEY_PATH="$HOME/.ssh/azure_vm_key"

# Create an SSH key if it does not exist
if [ ! -f "$SSH_KEY_PATH" ]; then
    echo "SSH key does not exist. Creating one now..."
    ssh-keygen -t rsa -b 2048 -f "$SSH_KEY_PATH" -N ""  # No passphrase
else
    echo "SSH key already exists."
fi

# Create the VM using the SSH key
az vm create \
  --resource-group "$RG" \
  --location "East US" \
  --name Azure-Ubuntu-VM \
  --image Ubuntu2204 \
  --admin-username azureuser \
  --authentication-type ssh \
  --ssh-key-value @"$SSH_KEY_PATH.pub" \
  --public-ip-address-allocation static \
  --nsg-rule SSH

echo "VM creation initiated"

# Get the public IP address of the VM
chmod 400 "$SSH_KEY_PATH"
export PUBLIC_IP=$(az vm show --resource-group "$RG" --name Azure-Ubuntu-VM --show-details --query publicIps -o tsv)
echo "Public IP Address: $PUBLIC_IP"
ssh -i "$SSH_KEY_PATH" azureuser@"$PUBLIC_IP"

# End