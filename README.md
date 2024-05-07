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