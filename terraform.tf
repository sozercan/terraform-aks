# create a resource group if it doesn't exist
resource "azurerm_resource_group" "test" {
  name     = "${var.terraform_azure_resource_group}"
  location = "${var.terraform_azure_region}"
}

# create azure container service
resource "azurerm_managed_cluster" "test" {
  name                   = "akstest"
  location               = "${azurerm_resource_group.test.location}"
  resource_group_name    = "${azurerm_resource_group.test.name}"
  dns_prefix             = "${var.terraform_aks_dns_prefix}"
  kubernetes_version     = "${var.terraform_aks_kubernetes_version}"

  linux_profile {
    admin_username = "${var.terraform_azure_admin_name}"

    ssh_key {
      key_data = "${var.terraform_azure_ssh_key}"
    }
  }

  agent_pool_profile {
    name       = "agentpool"
    count      = "${var.terraform_aks_agent_vm_count}"
    dns_prefix = "${var.terraform_aks_agent_dns_prefix}"
    vm_size    = "${var.terraform_aks_vm_size}"
    storage_profile = "ManagedDisks"
    os_type = "Linux"
  }

  service_principal {
    client_id     = "${var.terraform_azure_service_principal_client_id}"
    client_secret = "${var.terraform_azure_service_principal_client_secret}"
  }

  tags {
    Environment = "staging"
  }
}
