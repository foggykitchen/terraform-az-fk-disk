
module "data_disk" {
  source = "github.com/mlinxfeld/terraform-az-fk-disk"

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