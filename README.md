# Azure

- Azure CLI Installation

```bash
curl -sL https://aka.ms/InstallAzureCLIDeb | sudo bash
az --version
```

- Login to Azure

```bash
az login --use-device-code
az login
```

- Set Default Subscription

```bash
az account set --subscription "SUBSCRIPTION_ID"
```

- List all subscriptions

```bash
az account list --output table
```

- List current subscription

```bash
az account show --output table
```

- Create a Resource Group

```bash
az group create --name MyResourceGroup --location eastus
```

- List existing Resource Groups

```bash
az group list --output table
```

- Create a Virtual Machine

```bash
az container create \
  --resource-group MyResourceGroup \
  --name MyContainer \
  --image mcr.microsoft.com/azure-cli \
  --location eastus \
  --os-type Linux \
  --command-line "/bin/bash -c 'while true; do echo hello; sleep 20; done'" \
  --cpu 1 \
  --memory 1.5
```

```bash
az container create \
  --resource-group 1-f5ce1cb2-playground-sandbox \
  --name my-container \
  --image ubuntu:22.04 \
  --location eastus \
  --os-type Linux \
  --command-line "/bin/bash -c 'while true; do echo hello; sleep 20; done'" \
  --cpu 1 \
  --memory 1.5
```

- List existing Virtual Machines

```bash
az container list --output table
```

- Container Instances VS VM in Azure
```explain
Container instances and virtual machines (VMs) are quite different in how they operate and what they offer, although both can be used to run applications in Azure. Here’s a brief explanation of each and their differences:

Container Instances (ACI - Azure Container Instances)
Purpose: Designed to run containers quickly and with simplicity.
Infrastructure Management: You do not manage the host machine or the underlying infrastructure. Azure manages these for you, offering a serverless experience.
Scalability: Primarily meant for scenarios where you need burst compute with quick startup times. They are not for long-term persistent workloads.
Pricing: Generally, you pay per second for the CPU and memory resources your container uses.
Use Cases: Ideal for simple applications, task automation, and transient workloads.
Virtual Machines (VMs)
Purpose: Provide more control over the operating system and the environment. You can customize the VM's configuration, operating system, and the software it runs.
Infrastructure Management: Requires management of the OS, updates, and security patches. You have full control over the virtual hardware.
Scalability: Can be part of a larger, more complex deployment, such as a VM scale set for handling changes in load.
Pricing: Billing is generally per minute and depends on the VM size and options like reserved instances.
Use Cases: Suitable for legacy applications, more extensive and persistent workloads, and situations where specific OS tweaks or configurations are needed.
Differences in Usage:
Container Instances are lightweight, faster to start, and ideal for microservices architecture with stateless, short-lived applications.
Virtual Machines offer more flexibility, are suitable for stateful applications, and can handle tasks requiring persistent storage and extensive configuration.
```

- Run Latest Ubuntu LTS VM with Azure CLI

```bash
export RG=$(az group list --output json | jq -r '.[0].name')
az vm create \
  --resource-group "$RG" \
  --location "East US" \
  --name AzureUbuntuVM \
  --image Ubuntu2204 \
  --admin-username azureuser \
  --generate-ssh-keys \
  --public-ip-address-allocation static \
  --nsg-rule SSH
```

- To access a VM, use the following command:

```bash
az vm show --resource-group "$RG" --name AzureUbuntuVM --show-details --query publicIps -o tsv
chmod 400 ~/path/to/your/private_key
ssh -i ~/path/to/your/private_key azureuser@<public_ip>
```

- Create a Windows Server VM with ARM Template (IAC)
```bash
{
  "$schema": "https://schema.management.azure.com/schemas/2019-04-01/deploymentTemplate.json#",
  "contentVersion": "1.0.0.0",
  "parameters": {
    "adminUsername": {
      "type": "string",
      "metadata": {
        "description": "Username for the Virtual Machine."
      }
    },
    "adminPassword": {
      "type": "secureString",
      "minLength": 12,
      "metadata": {
        "description": "Password for the Virtual Machine."
      }
    },
    "dnsLabelPrefix": {
      "type": "string",
      "defaultValue": "[toLower(format('{0}-{1}', parameters('vmName'), uniqueString(resourceGroup().id, parameters('vmName'))))]",
      "metadata": {
        "description": "Unique DNS Name for the Public IP used to access the Virtual Machine."
      }
    },
    "publicIpName": {
      "type": "string",
      "defaultValue": "myPublicIP",
      "metadata": {
        "description": "Name for the Public IP used to access the Virtual Machine."
      }
    },
    "publicIPAllocationMethod": {
      "type": "string",
      "defaultValue": "Dynamic",
      "allowedValues": [
        "Dynamic",
        "Static"
      ],
      "metadata": {
        "description": "Allocation method for the Public IP used to access the Virtual Machine."
      }
    },
    "publicIpSku": {
      "type": "string",
      "defaultValue": "Basic",
      "allowedValues": [
        "Basic",
        "Standard"
      ],
      "metadata": {
        "description": "SKU for the Public IP used to access the Virtual Machine."
      }
    },
    "OSVersion": {
      "type": "string",
      "defaultValue": "2022-datacenter-azure-edition-core",
      "allowedValues": [
        "2008-R2-SP1",
        "2008-R2-SP1-smalldisk",
        "2012-Datacenter",
        "2012-datacenter-gensecond",
        "2012-Datacenter-smalldisk",
        "2012-datacenter-smalldisk-g2",
        "2012-Datacenter-zhcn",
        "2012-datacenter-zhcn-g2",
        "2012-R2-Datacenter",
        "2012-r2-datacenter-gensecond",
        "2012-R2-Datacenter-smalldisk",
        "2012-r2-datacenter-smalldisk-g2",
        "2012-R2-Datacenter-zhcn",
        "2012-r2-datacenter-zhcn-g2",
        "2016-Datacenter",
        "2016-datacenter-gensecond",
        "2016-datacenter-gs",
        "2016-Datacenter-Server-Core",
        "2016-datacenter-server-core-g2",
        "2016-Datacenter-Server-Core-smalldisk",
        "2016-datacenter-server-core-smalldisk-g2",
        "2016-Datacenter-smalldisk",
        "2016-datacenter-smalldisk-g2",
        "2016-Datacenter-with-Containers",
        "2016-datacenter-with-containers-g2",
        "2016-datacenter-with-containers-gs",
        "2016-Datacenter-zhcn",
        "2016-datacenter-zhcn-g2",
        "2019-Datacenter",
        "2019-Datacenter-Core",
        "2019-datacenter-core-g2",
        "2019-Datacenter-Core-smalldisk",
        "2019-datacenter-core-smalldisk-g2",
        "2019-Datacenter-Core-with-Containers",
        "2019-datacenter-core-with-containers-g2",
        "2019-Datacenter-Core-with-Containers-smalldisk",
        "2019-datacenter-core-with-containers-smalldisk-g2",
        "2019-datacenter-gensecond",
        "2019-datacenter-gs",
        "2019-Datacenter-smalldisk",
        "2019-datacenter-smalldisk-g2",
        "2019-Datacenter-with-Containers",
        "2019-datacenter-with-containers-g2",
        "2019-datacenter-with-containers-gs",
        "2019-Datacenter-with-Containers-smalldisk",
        "2019-datacenter-with-containers-smalldisk-g2",
        "2019-Datacenter-zhcn",
        "2019-datacenter-zhcn-g2",
        "2022-datacenter",
        "2022-datacenter-azure-edition",
        "2022-datacenter-azure-edition-core",
        "2022-datacenter-azure-edition-core-smalldisk",
        "2022-datacenter-azure-edition-smalldisk",
        "2022-datacenter-core",
        "2022-datacenter-core-g2",
        "2022-datacenter-core-smalldisk",
        "2022-datacenter-core-smalldisk-g2",
        "2022-datacenter-g2",
        "2022-datacenter-smalldisk",
        "2022-datacenter-smalldisk-g2"
      ],
      "metadata": {
        "description": "The Windows version for the VM. This will pick a fully patched image of this given Windows version."
      }
    },
    "vmSize": {
      "type": "string",
      "defaultValue": "Standard_B2s",
      "metadata": {
        "description": "Size of the virtual machine."
      }
    },
    "location": {
      "type": "string",
      "defaultValue": "[resourceGroup().location]",
      "metadata": {
        "description": "Location for all resources."
      }
    },
    "vmName": {
      "type": "string",
      "defaultValue": "vm-demo-002",
      "metadata": {
        "description": "Name of the virtual machine."
      }
    }
  },
  "variables": {
    "storageAccountName": "[format('bootdiags{0}', uniqueString(resourceGroup().id))]",
    "nicName": "myVMNic",
    "addressPrefix": "10.0.0.0/16",
    "subnetName": "Subnet",
    "subnetPrefix": "10.0.0.0/24",
    "virtualNetworkName": "MyVNET",
    "networkSecurityGroupName": "default-NSG"
  },
  "resources": [
    {
      "type": "Microsoft.Storage/storageAccounts",
      "apiVersion": "2021-04-01",
      "name": "[variables('storageAccountName')]",
      "location": "[parameters('location')]",
      "sku": {
        "name": "Standard_LRS"
      },
      "kind": "Storage"
    },
    {
      "type": "Microsoft.Network/publicIPAddresses",
      "apiVersion": "2021-02-01",
      "name": "[parameters('publicIpName')]",
      "location": "[parameters('location')]",
      "sku": {
        "name": "[parameters('publicIpSku')]"
      },
      "properties": {
        "publicIPAllocationMethod": "[parameters('publicIPAllocationMethod')]",
        "dnsSettings": {
          "domainNameLabel": "[parameters('dnsLabelPrefix')]"
        }
      }
    },
    {
      "type": "Microsoft.Network/networkSecurityGroups",
      "apiVersion": "2021-02-01",
      "name": "[variables('networkSecurityGroupName')]",
      "location": "[parameters('location')]",
      "properties": {
        "securityRules": [
          {
            "name": "default-allow-3389",
            "properties": {
              "priority": 1000,
              "access": "Allow",
              "direction": "Inbound",
              "destinationPortRange": "3389",
              "protocol": "Tcp",
              "sourcePortRange": "*",
              "sourceAddressPrefix": "*",
              "destinationAddressPrefix": "*"
            }
          }
        ]
      }
    },
    {
      "type": "Microsoft.Network/virtualNetworks",
      "apiVersion": "2021-02-01",
      "name": "[variables('virtualNetworkName')]",
      "location": "[parameters('location')]",
      "properties": {
        "addressSpace": {
          "addressPrefixes": [
            "[variables('addressPrefix')]"
          ]
        },
        "subnets": [
          {
            "name": "[variables('subnetName')]",
            "properties": {
              "addressPrefix": "[variables('subnetPrefix')]",
              "networkSecurityGroup": {
                "id": "[resourceId('Microsoft.Network/networkSecurityGroups', variables('networkSecurityGroupName'))]"
              }
            }
          }
        ]
      },
      "dependsOn": [
        "[resourceId('Microsoft.Network/networkSecurityGroups', variables('networkSecurityGroupName'))]"
      ]
    },
    {
      "type": "Microsoft.Network/networkInterfaces",
      "apiVersion": "2021-02-01",
      "name": "[variables('nicName')]",
      "location": "[parameters('location')]",
      "properties": {
        "ipConfigurations": [
          {
            "name": "ipconfig1",
            "properties": {
              "privateIPAllocationMethod": "Dynamic",
              "publicIPAddress": {
                "id": "[resourceId('Microsoft.Network/publicIPAddresses', parameters('publicIpName'))]"
              },
              "subnet": {
                "id": "[resourceId('Microsoft.Network/virtualNetworks/subnets', variables('virtualNetworkName'), variables('subnetName'))]"
              }
            }
          }
        ]
      },
      "dependsOn": [
        "[resourceId('Microsoft.Network/publicIPAddresses', parameters('publicIpName'))]",
        "[resourceId('Microsoft.Network/virtualNetworks', variables('virtualNetworkName'))]"
      ]
    },
    {
      "type": "Microsoft.Compute/virtualMachines",
      "apiVersion": "2021-03-01",
      "name": "[parameters('vmName')]",
      "location": "[parameters('location')]",
      "properties": {
        "hardwareProfile": {
          "vmSize": "[parameters('vmSize')]"
        },
        "osProfile": {
          "computerName": "[parameters('vmName')]",
          "adminUsername": "[parameters('adminUsername')]",
          "adminPassword": "[parameters('adminPassword')]"
        },
        "storageProfile": {
          "imageReference": {
            "publisher": "MicrosoftWindowsServer",
            "offer": "WindowsServer",
            "sku": "[parameters('OSVersion')]",
            "version": "latest"
          },
          "osDisk": {
            "createOption": "FromImage",
            "managedDisk": {
              "storageAccountType": "StandardSSD_LRS"
            }
          },
          "dataDisks": [
            {
              "diskSizeGB": 1023,
              "lun": 0,
              "createOption": "Empty"
            }
          ]
        },
        "networkProfile": {
          "networkInterfaces": [
            {
              "id": "[resourceId('Microsoft.Network/networkInterfaces', variables('nicName'))]"
            }
          ]
        },
        "diagnosticsProfile": {
          "bootDiagnostics": {
            "enabled": true,
            "storageUri": "[reference(resourceId('Microsoft.Storage/storageAccounts', variables('storageAccountName'))).primaryEndpoints.blob]"
          }
        }
      },
      "dependsOn": [
        "[resourceId('Microsoft.Network/networkInterfaces', variables('nicName'))]",
        "[resourceId('Microsoft.Storage/storageAccounts', variables('storageAccountName'))]"
      ]
    }
  ],
  "outputs": {
    "hostname": {
      "type": "string",
      "value": "[reference(resourceId('Microsoft.Network/publicIPAddresses', parameters('publicIpName'))).dnsSettings.fqdn]"
    }
  }
}
```
