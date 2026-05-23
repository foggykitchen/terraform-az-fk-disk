# Example 02: Single Azure Virtual Machine with Multiple Managed Data Disks

This example extends **Example 01** by attaching **multiple Azure
Managed Data Disks** to a **single Linux Virtual Machine** using
**Terraform / OpenTofu**.

The purpose of this example is to demonstrate how Azure models
**multiple persistent disks** and how they are explicitly attached to a
VM using **Logical Unit Numbers (LUNs)**.

------------------------------------------------------------------------

## 🧭 Architecture Overview

This deployment builds on the same minimal compute and networking
foundation as the single-disk example, but introduces **multiple data
disks** attached to the same VM.

<img src="02-vm-multiple-disks-architecture.png" width="900"/>

This example creates:

-   One **Linux Virtual Machine**
-   One **OS Disk** (managed by Azure)
-   Two **Managed Data Disks**
    -   `data01` attached at **LUN 0**
    -   `data02` attached at **LUN 1**
-   A basic Virtual Network and subnet

This remains a **compute + storage baseline**, not a production-ready
architecture.

------------------------------------------------------------------------

## 🎯 Why this example exists

Many real-world workloads require more than one persistent disk:

-   separation of **application data** and **logs**
-   databases with dedicated data and temp volumes
-   predictable I/O isolation between workloads

This example teaches:

-   how Azure attaches **multiple Managed Disks** to a single VM
-   how **LUN numbering** works in practice
-   how disk size and performance tiers can differ per disk
-   how Terraform models multiple disk attachments cleanly using
    `for_each`

This pattern is foundational for advanced compute designs and for
understanding persistent volumes in Kubernetes.

------------------------------------------------------------------------

## 🚀 Deployment Steps

From the example directory:

``` bash
tofu init
tofu plan
tofu apply
```

Terraform will output the public IP address of the VM after deployment.

------------------------------------------------------------------------

## 🖼️ Azure Portal Verification

After deployment, navigate to:

**Virtual Machine → Disks**

You should observe:

-   One **OS disk**
-   Two **data disks** attached to the VM
-   Each disk attached at a distinct **LUN**
-   Different disk sizes and performance characteristics

<img src="02-vm-multiple-disks-portal.png" width="900"/>

*Figure 1. Linux Virtual Machine with multiple Managed Data Disks
attached at distinct LUNs.*

------------------------------------------------------------------------

## 🔍 VM-Level Verification (optional)

Connect to the VM via SSH:

``` bash
ssh azureuser@<vm_public_ip>
```

List block devices:

``` bash
lsblk
```

You should see multiple additional block devices corresponding to the
attached Managed Disks.

Each device represents a **persistent Azure Managed Disk**.

------------------------------------------------------------------------

## 🧹 Cleanup

Remove all resources when finished:

``` bash
tofu destroy
```

------------------------------------------------------------------------

## 🪪 License

Licensed under the **Universal Permissive License (UPL), Version 1.0**.


---

© 2026 [FoggyKitchen.com](https://foggykitchen.com) - Cloud. Code. Clarity.
