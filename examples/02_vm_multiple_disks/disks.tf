
module "data_disk" {
  for_each = var.data_disks
  source = "github.com/mlinxfeld/terraform-az-fk-disk"

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