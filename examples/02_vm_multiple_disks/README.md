# Example 02: Single Azure Virtual Machine with Multiple Managed Data Disks

This example demonstrates how to provision a **single Linux Virtual
Machine** with **multiple Azure Managed Data Disks** using **Terraform /
OpenTofu**.

It focuses on a storage design problem that starts the moment a VM gets
more than one persistent disk:

> **multi-disk persistence in Azure is an architectural decision, not
> just an attachment detail**

This example is the runnable companion to the FoggyKitchen article
[Azure Managed Disks with Terraform: Designing Multi-Disk VM Persistence (The Right Way)](https://foggykitchen.com/2026/01/21/azure-managed-disks-terraform/).

------------------------------------------------------------------------

## 🏗️ Architecture Overview

This deployment creates:

-   one **Linux Virtual Machine**
-   one **OS disk** managed by Azure
-   two independent **Managed Data Disks**
-   explicit **LUN-based attachment**
-   one **Virtual Network** with a public subnet

The goal is to establish a clear persistence model, not to build a full
platform.

<img src="02-vm-multiple-disks-architecture.png" width="900"/>

*Figure 1. Azure Virtual Machine with multiple Managed Data Disks
attached using explicit LUN assignments.*

------------------------------------------------------------------------

## 🧩 Module Composition

This example is composed from reusable FoggyKitchen modules:

-   `terraform-az-fk-compute` provisions the Linux VM
-   `terraform-az-fk-vnet` provides the minimal network foundation
-   `terraform-az-fk-disk` creates and attaches each data disk

The modules are independent. The architecture emerges from how they are
connected:

-   the compute module exposes `vm_id`
-   the disk module uses that `vm_id` for attachment
-   each disk keeps its own size, SKU, and LUN definition

This keeps **compute** and **persistence** concerns separated.

------------------------------------------------------------------------

## 🎯 What this example teaches

This example shows how to model multi-disk persistence cleanly:

-   disks are separate Azure resources
-   LUNs are assigned explicitly
-   disk performance tiers can differ per attachment
-   the VM lifecycle stays decoupled from disk lifecycle

This matters because Managed Disks are not only VM properties. They are
first-class Azure resources that should be designed intentionally.

------------------------------------------------------------------------

## Declarative Disk Definition

Disks are defined as input data, not hardcoded resources:

```hcl
variable "data_disks" {
  type = map(object({
    size_gb = number
    sku     = string
    lun     = number
  }))
}
```

Example configuration used by this example:

```hcl
data_disks = {
  data01 = {
    size_gb = 64
    sku     = "Premium_LRS"
    lun     = 0
  }
  data02 = {
    size_gb = 128
    sku     = "Premium_LRS"
    lun     = 1
  }
}
```

This gives you predictable device mapping and makes it easy to add or
modify disks without rewriting the VM definition.

------------------------------------------------------------------------

## Attaching Multiple Disks with the Module

The core pattern in this example is a `for_each` loop over the disk
definition map:

```hcl
module "data_disk" {
  for_each = var.data_disks
  source   = "github.com/foggykitchen/terraform-az-fk-disk"

  name                = "${var.disk_name}-${each.key}"
  resource_group_name = azurerm_resource_group.foggykitchen_rg.name
  location            = azurerm_resource_group.foggykitchen_rg.location
  tags                = var.tags

  disk_size_gb         = each.value.size_gb
  storage_account_type = each.value.sku

  attach_to_vm = true
  vm_id        = module.compute.vm_id

  lun     = each.value.lun
  caching = "ReadOnly"
}
```

Each disk is:

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

-   one OS disk
-   two data disks attached to the same VM
-   `fkdisk-data01` attached at **LUN 0**
-   `fkdisk-data02` attached at **LUN 1**
-   separate size and performance settings per disk

<img src="02-vm-multiple-disks-portal.png" width="900"/>

*Figure 2. Azure Portal view showing multiple Managed Data Disks
attached through explicit LUN assignments.*

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

You should see additional block devices corresponding to the attached
Managed Disks.

------------------------------------------------------------------------

## Why this separation matters

With this design:

-   the VM can be recreated without redefining storage intent
-   disks can evolve independently
-   snapshots and backups are easier to reason about
-   persistence becomes visible in code, not hidden inside the VM

That is the main idea behind the related article:
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
