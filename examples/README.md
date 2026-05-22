# Azure Managed Disks with Terraform/OpenTofu - Training Examples

This directory contains all **disk-focused training examples** built
around the `terraform-az-fk-disk` module.

The examples are designed as **progressive building blocks** that
introduce **persistent storage for Azure Virtual Machines** - starting
from a single data disk and extending to **multiple managed disks
attached to the same VM**.

These examples deliberately focus on **storage fundamentals** and avoid
advanced compute or platform abstractions.

They are part of the **[FoggyKitchen.com training ecosystem](https://foggykitchen.com/courses-2/)** and are
used across:

-   Azure Fundamentals with Terraform/OpenTofu
-   Azure Compute & Storage deep dives
-   AKS and platform integration courses
-   Multicloud (Azure + OCI) architectural training

---

## 🧭 Example Overview

| Example | Title | Key Topics |
|------|------|-----------|
| 01 | **Single VM with Managed Data Disk** |  OS disk vs data disk, disk attachment, persistence baseline
| 02 | **Single VM with Multiple Data Disks** | Multiple managed disks, LUN  numbering, disk separation patterns

Each example introduces **one clear storage concept** and can be applied **independently** for learning,experimentation, or reuse.

---

## ⚙️ How to Use

Each example directory contains:

-   Terraform/OpenTofu configuration (`.tf`)
-   A focused `README.md` explaining the architectural goal
-   A **minimal, runnable deployment** (no placeholders, no mock
    resources)

To run an example:

``` bash
cd examples/01_vm_single_disk
tofu init
tofu plan
tofu apply
```

You may apply examples independently, but the **recommended learning
path** is sequential:

    01 → 02

This mirrors real-world Azure storage design: start with a single
persistent disk, then scale the same concept to multiple disks with
explicit roles and performance characteristics.

---

## 🧩 Design Principles

These examples follow strict design rules:

-   One example = one storage concept
-   Explicit modeling of **Managed Disks** (no hidden attachments)
-   Clear separation of concerns:
    -   compute (VM)
    -   storage (Managed Disks)
    -   networking (kept minimal)
-   No VM Scale Sets, no autoscaling, no Load Balancers
-   No AKS abstractions (covered in the AKS module)

The examples intentionally avoid:

-   Enterprise landing zone patterns
-   Opinionated frameworks
-   Cross-example dependencies
-   Implicit or "magic" resource creation

The goal is **clarity and correctness**, not completeness.

---

## 🔗 Related Modules & Training

-   [FoggyKitchen Azure Disk Module (terraform-az-fk-disk)](../)
-   [FoggyKitchen Azure Compute Module
    (terraform-az-fk-compute)](https://github.com/foggykitchen/terraform-az-fk-compute)
-   [FoggyKitchen Azure VNet Module
    (terraform-az-fk-vnet)](https://github.com/foggykitchen/terraform-az-fk-vnet)
-   [FoggyKitchen Azure Storage Module
    (terraform-az-fk-storage)](https://github.com/mlinxfeld/terraform-az-fk-storage)
-   [FoggyKitchen AKS Module
    (terraform-az-fk-aks)](https://github.com/mlinxfeld/terraform-az-fk-aks)
-   [OCI OKE Module
    (terraform-oci-fk-oke)](https://github.com/foggykitchen/terraform-oci-fk-oke)

---

## 🪪 License

Licensed under the **Universal Permissive License (UPL), Version 1.0**.
See `LICENSE` for details.

---

© 2026 FoggyKitchen.com --- Cloud. Code. Clarity.
