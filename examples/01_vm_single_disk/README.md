# Example 01: Single Azure Virtual Machine with Managed Data Disk

This example demonstrates how to provision a **single Linux Virtual
Machine** with a **dedicated Azure Managed Data Disk** using **Terraform
/ OpenTofu**.

It focuses on the storage foundation behind every more advanced Azure VM
design:

> **persistent storage in Azure starts with Managed Disks, not with the
> OS filesystem**

If you want to see how this single-disk foundation evolves into a
multi-disk persistence design, see the related article
[Azure Managed Disks with Terraform: Designing Multi-Disk VM Persistence (The Right Way)](https://foggykitchen.com/2026/01/21/azure-managed-disks-terraform/).

------------------------------------------------------------------------

## 🏗️ Architecture Overview

This deployment creates:

-   one **Linux Virtual Machine**
-   one **OS disk** managed by Azure
-   one **Managed Data Disk** attached at **LUN 0**
-   one **Virtual Network** with a public subnet

The goal is to establish the simplest possible persistence model for a
VM, not to build a full platform.

<img src="01-vm-single-disk-architecture.png" width="900"/>

*Figure 1. Single Azure Virtual Machine deployed with one dedicated
Managed Data Disk attached through an explicit LUN assignment.*

------------------------------------------------------------------------

## 🧩 Module Composition

This example is composed from reusable FoggyKitchen modules:

-   `terraform-az-fk-compute` provisions the Linux VM
-   `terraform-az-fk-vnet` provides the minimal network foundation
-   `terraform-az-fk-disk` creates and attaches the data disk

The modules are independent. The architecture emerges from how they are
connected:

-   the compute module exposes `vm_id`
-   the disk module uses that `vm_id` for attachment
-   storage is modeled outside the VM definition

This keeps **compute** and **persistence** concerns separated from the
start.

------------------------------------------------------------------------

## 🎯 What this example teaches

This example shows the storage baseline for Azure VMs:

-   the difference between **OS disks** and **data disks**
-   Managed Disks as separate Azure resources
-   explicit attachment at **LUN 0**
-   why application data should live outside the OS filesystem

This is the foundation for every later pattern involving multiple data
disks, stateful workloads, or platform-level persistence.

------------------------------------------------------------------------

## Declarative Disk Definition

The disk properties are defined as input variables:

```hcl
variable "disk_size_gb" {
  type = number
}

variable "disk_sku" {
  type = string
}
```

Example values used by this example:

```hcl
disk_size_gb = 64
disk_sku     = "Premium_LRS"
```

This makes the persistence intent visible without mixing storage details
into application logic.

------------------------------------------------------------------------

## Attaching the Disk with the Module

The data disk is created and attached explicitly:

```hcl
module "data_disk" {
  source = "github.com/foggykitchen/terraform-az-fk-disk"

  name                = var.disk_name
  resource_group_name = azurerm_resource_group.foggykitchen_rg.name
  location            = azurerm_resource_group.foggykitchen_rg.location
  tags                = var.tags

  disk_size_gb         = var.disk_size_gb
  storage_account_type = var.disk_sku

  attach_to_vm = true
  vm_id        = module.compute.vm_id

  lun     = 0
  caching = "ReadOnly"
}
```

This means the disk is:

-   created as a standalone Managed Disk
-   attached explicitly to the VM
-   controlled independently from compute logic

------------------------------------------------------------------------

## 🚀 How to Run This Example

From the example directory:

```bash
tofu init
tofu plan
tofu apply
```

After a successful apply, Terraform/OpenTofu will output the public IP
address of the VM.

------------------------------------------------------------------------

## 🔍 What to Validate

After deployment, navigate to:

**Virtual Machine → Disks**

You should observe:

-   one OS disk attached to the VM
-   one separate Managed Data Disk
-   the data disk attached at **LUN 0**
-   clear separation between OS storage and persistent application
    storage

![Azure VM Disks View](01-vm-single-disk-portal.png)

*Figure 2. Azure Portal view showing a Linux Virtual Machine with one
dedicated Managed Data Disk attached through Terraform/OpenTofu.*

------------------------------------------------------------------------

## 🖥️ VM-Level Verification (optional)

Connect to the VM:

```bash
ssh azureuser@<vm_public_ip>
```

List block devices:

```bash
lsblk
```

You should see an additional disk device corresponding to the attached
Managed Disk.

------------------------------------------------------------------------

## Why this separation matters

With this design:

-   application data can live outside the OS filesystem
-   persistence remains visible in infrastructure code
-   storage can be reasoned about independently from the VM
-   the architecture is ready to grow into a multi-disk design

The natural next step from this example is the multi-disk pattern
described here:
[Azure Managed Disks with Terraform: Designing Multi-Disk VM Persistence (The Right Way)](https://foggykitchen.com/2026/01/21/azure-managed-disks-terraform/).

------------------------------------------------------------------------

## Related Resources

-   [Azure Managed Disks with Terraform: Designing Multi-Disk VM Persistence (The Right Way)](https://foggykitchen.com/2026/01/21/azure-managed-disks-terraform/)
-   [terraform-az-fk-disk](https://github.com/foggykitchen/terraform-az-fk-disk)
-   [terraform-az-fk-compute](https://github.com/foggykitchen/terraform-az-fk-compute)
-   [terraform-az-fk-vnet](https://github.com/foggykitchen/terraform-az-fk-vnet)

------------------------------------------------------------------------

## 🧹 Cleanup

When finished, remove all resources:

```bash
tofu destroy
```

------------------------------------------------------------------------

## 🪪 License

Licensed under the **Universal Permissive License (UPL), Version 1.0**.


---

© 2026 [FoggyKitchen.com](https://foggykitchen.com) - Cloud. Code. Clarity.
