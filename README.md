# terraform-az-fk-disk

This repository contains a reusable **Terraform / OpenTofu module** and
progressive examples for deploying **Azure Managed Disks** and attaching
them to **Virtual Machines** in a clean, explicit, and
architecture-aware way.

It is part of the **[FoggyKitchen.com training ecosystem](https://foggykitchen.com/courses/azure-fundamentals-terraform-course/)** and is
designed as a dedicated **storage persistence layer** for Azure compute
workloads.

This module is also part of the **[Azure Fundamentals with Terraform/OpenTofu — Build Real-World Azure Architectures with Reusable Modules (2026 Edition)](https://foggykitchen.com/courses/azure-fundamentals-terraform-course/)** course. In the training, it is used to show how persistent storage is modeled separately from virtual machines while still composing cleanly with compute-focused modules.

---

## 🎯 Purpose

The goal of this repository is to provide a **clear, educational, and
composable reference implementation** for **Azure Managed Disks** using
Infrastructure as Code.

It focuses on:

-   Azure Managed Disks as **first-class resources**
-   Explicit disk creation and attachment
-   Separation between **OS disks** and **data disks**
-   Persistence boundaries at the Virtual Machine level
-   Clean Terraform/OpenTofu modeling of disk lifecycles

This is **not** a landing zone, platform framework, or full compute
solution. It is a **learning-first building block** that integrates with
other FoggyKitchen modules.

---

## ✨ What the module does

Depending on configuration and example used, the module can:

-   Create Azure **Managed Disks**
-   Control disk size and performance tier (SKU)
-   Attach data disks explicitly to **Linux Virtual Machines**
-   Expose disk identifiers and attachment state as outputs

The module intentionally does **not** create or manage:

-   Virtual Machines themselves
-   Virtual Machine Scale Sets (VMSS)
-   Virtual Networks or subnets
-   Network Security Groups
-   Load Balancers
-   Snapshots or backups
-   Encryption Sets (CMK)

Each of those concerns belongs in its own dedicated module.

---

## 📂 Repository Structure

``` bash
terraform-az-fk-disk/
├── examples/
│   ├── 01_vm_single_disk/
│   ├── 02_vm_multiple_disks/
│   └── README.md
├── main.tf
├── inputs.tf
├── outputs.tf
├── versions.tf
├── LICENSE
└── README.md
```

---

## 🚀 Example Usage

``` hcl
module "data_disk" {
  source = "git::https://github.com/foggykitchen/terraform-az-fk-disk.git?ref=v1.0.0"

  name                = "fkdisk-data01"
  location            = "westeurope"
  resource_group_name = "fk-rg"

  disk_size_gb         = 64
  storage_account_type = "Premium_LRS"

  attach_to_vm = true
  vm_id        = azurerm_linux_virtual_machine.this.id

  lun     = 0
  caching = "ReadOnly"

  tags = {
    project = "foggykitchen"
    env     = "dev"
  }
}
```

---

## 📤 Outputs

| Output | Description |
|------|-------------|
| `disk_id` | ID of the created Managed Disk.
| `disk_name` | Name of the Managed Disk.
| `disk_size_gb` | Size of the disk in GB.
| `storage_account_type` | Disk SKU (Standard / Premium / Ultra).
| `attached_to_vm` | Indicates whether the disk is attached to a VM.
| `lun` | Logical Unit Number used for attachment.

---

## 🧠 Design Philosophy

-   Persistence starts with **Managed Disks**, not the OS filesystem
-   Disk attachment must be **explicit and visible**
-   One module = one responsibility
-   Examples teach **patterns**, not just syntax
-   Terraform code should reflect Azure's real resource model
-   Storage and compute lifecycles are **deliberately separated**

This repository intentionally avoids abstraction layers that hide how
disks actually behave in Azure.

---

## 🧩 Related Modules & Training

-   [terraform-az-fk-vnet](https://github.com/foggykitchen/terraform-az-fk-vnet)
-   [terraform-az-fk-compute](https://github.com/mlinxfeld/terraform-az-fk-compute)
-   [terraform-az-fk-storage](https://github.com/foggykitchen/terraform-az-fk-storage)
-   [terraform-az-fk-aks](https://github.com/mlinxfeld/terraform-az-fk-aks)
-   [terraform-oci-fk-oke](https://github.com/foggykitchen/terraform-oci-fk-oke)

---

## 🪪 License

Licensed under the **Universal Permissive License (UPL), Version 1.0**.
See [LICENSE](LICENSE) for details.

---

© 2026 [FoggyKitchen.com](https://foggykitchen.com) - Cloud. Code. Clarity.
