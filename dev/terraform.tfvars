rgs = {
  rg1 = {
    name       = "shahed-dev-01"
    location   = "centralindia"
    managed_by = "marketing-team"
    tags = {
      owner       = "marketing-team"
      environment = "dev-01"
    }
  }
}
storages = {
  storage1 = {
    name                              = "shahedstg1995"
    location                          = "centralindia"
    resource_group_name               = "shahed-dev-01"
    account_tier                      = "Standard"
    account_replication_type          = "LRS"
    account_kind                      = "BlobStorage"
    access_tier                       = "Hot"
    cross_tenant_replication_enabled  = false
    edge_zone                         = null
    https_traffic_only_enabled        = true
    min_tls_version                   = "TLS1_2"
    allow_nested_items_to_be_public   = true
    shared_access_key_enabled         = true
    public_network_access_enabled     = true
    default_to_oauth_authentication   = false
    is_hns_enabled                    = false
    nfsv3_enabled                     = false
    large_file_share_enabled          = false
    local_user_enabled                = true
    queue_encryption_key_type         = "Service"
    table_encryption_key_type         = "Service"
    infrastructure_encryption_enabled = false
    allowed_copy_scope                = null
    sftp_enabled                      = false
    dns_endpoint_type                 = "Standard"

    network_rules = {
      default_action             = "Deny"
      bypass                     = ["AzureServices"]
      ip_rules                   = ["52.160.10.5", "40.76.1.0/24"]
      virtual_network_subnet_ids = []
    }
  }
}

vnets = {
  dev-vnet1 = {
    vnet_name           = "shahed-vnet"
    location            = "centralindia"
    resource_group_name = "shahed-dev-01"
    address_space       = ["10.2.0.0/16"]
    dns_servers         = ["10.1.1.4"]

    # Required AzureRM defaults
    flow_timeout_in_minutes        = 4
    private_endpoint_vnet_policies = "Disabled"
    edge_zone                      = null
    bgp_community                  = null
    tags                           = { environment = "dev" }

    # Optional nested blocks
    ddos_protection_plan = null
    encryption           = null
    ip_address_pool      = null

    # Subnets
    subnets = [
      {
        name             = "frontend-01-subnet"
        address_prefixes = ["10.2.1.0/24"]
      },
      {
        name             = "backend-01-subnet"
        address_prefixes = ["10.2.2.0/24"]
      },
      {
        name             = "AzureBastionSubnet"
        address_prefixes = ["10.2.3.0/26"]  # Make sure it doesn't overlap
      },
      {
        name             = "appgw-subnet"
        address_prefixes = ["10.2.4.0/24"] # AGW subnet
      }
    ]
  }
}


nsgs = {
  "frontend-nsg" = {
    name                = "frontend-nsg"
    location            = "Central India"
    resource_group_name = "shahed-dev-01"
    security_rules = [
      {
        name                       = "allow-ssh"
        priority                   = 100
        direction                  = "Inbound"
        access                     = "Allow"
        protocol                   = "Tcp"
        source_port_range          = "*"
        destination_port_range     = "22"
        source_address_prefix      = "*"
        destination_address_prefix = "*"

      },
      {
        name                       = "allow-http"
        priority                   = 110
        direction                  = "Inbound"
        access                     = "Allow"
        protocol                   = "Tcp"
        destination_port_range     = "80"
        source_port_range          = "*"
        destination_port_range     = "1433"
        source_address_prefix      = "*"
        destination_address_prefix = "*"
      }
    ]
    tags = {
      environment = "dev"
      project     = "webapp"
    }
  }

  "backend-nsg" = {
    name                = "backend-nsg"
    location            = "Central India"
    resource_group_name = "shahed-dev-01"
    security_rules = [
      {
        name                       = "allow-sql"
        priority                   = 100
        direction                  = "Inbound"
        access                     = "Allow"
        protocol                   = "Tcp"
        source_port_range          = "*"
        destination_port_range     = "1433"
        source_address_prefix      = "*"
        destination_address_prefix = "*"
      }
    ]
    tags = {
      environment = "dev"
      project     = "database"
    }
  }
}


pips = {
  # pip1 = {
  #   name                = "frontend-dev-pip"
  #   resource_group_name = "shahed-dev-01"
  #   location            = "centralindia"
  #   allocation_method   = "Static"
  #   tags = {
  #     app = "frontend"
  #     env = "dev"
  #   }
  #   }, pip2 = {
  #   name                = "backend-dev-pip"
  #   resource_group_name = "shahed-dev-01"
  #   location            = "centralindia"
  #   allocation_method   = "Static"
  #   tags = {
  #     app = "backend"
  #     env = "dev"
  #   }
  # },
  pip3 = {
    name                = "loadbalancer-dev-pip"
    resource_group_name = "shahed-dev-01"
    location            = "centralindia"
    allocation_method   = "Static"
    tags = {
      app = "lb"
      env = "dev"
    }
  },
    # Public IP for Bastion host (key matches bastion_hosts)
  dev_bastion = {
    name                = "bastion-dev-pip"
    resource_group_name = "shahed-dev-01"
    location            = "centralindia"
    allocation_method   = "Static"
    tags = {
      app = "bastion"
      env = "dev"
    }
  },
  agw_dev = {
    name                = "agw-dev-pip"
    resource_group_name = "shahed-dev-01"
    location            = "centralindia"
    allocation_method   = "Static"
    tags = {
      app = "appgw"
      env = "dev"
    }
  }
}
 
vms = {
  vm1 = {
    nic_name             = "shahed-frontend-nic"
    location             = "Central India" # Corrected capitalization
    resource_group_name  = "shahed-dev-01"
    virtual_network_name = "shahed-vnet"
    subnet_name          = "frontend-01-subnet"
    pip_name             = "frontend-dev-pip"
    vm_name              = "frontend-vm01"
    size                 = "Standard_F2s_v2"
    nsg_name             = "frontend-dev-nsg" # Corrected typo
    admin_username       = "adminuser"
    admin_password       = "Admin@12345678"
    nsg_key              = "frontend-nsg" # Must match key in NSG map
    source_image_reference = {
      publisher = "Canonical"
      offer     = "0001-com-ubuntu-server-jammy"
      sku       = "22_04-lts"
      version   = "latest"
    }
    custom_data_file = "scripts/install-nginx.sh"
  }

  vm2 = {
    nic_name             = "shahed-backend-nic"
    location             = "Central India"
    resource_group_name  = "shahed-dev-01"
    virtual_network_name = "shahed-vnet"
    subnet_name          = "backend-01-subnet"
    pip_name             = "backend-dev-pip"
    vm_name              = "backend-vm01"
    size                 = "Standard_F2s_v2"
    nsg_name             = "backend-dev-nsg"
    admin_username       = "adminuser"
    admin_password       = "Admin@12345678"
    nsg_key              = "backend-nsg"
    source_image_reference = {
      publisher = "Canonical"
      offer     = "0001-com-ubuntu-server-jammy"
      sku       = "22_04-lts"
      version   = "latest"
    }
  }
  custom_data_file = "scripts/init-script.sh"
}

key_vaults = {
  kv1 = {
    name                        = "shahed-kv1"
    location                    = "centralindia"
    resource_group_name         = "shahed-dev-01"
    enabled_for_disk_encryption = true
    soft_delete_retention_days  = 7
    purge_protection_enabled    = false
    sku_name                    = "standard"

    access_policy = {
      key_permissions     = ["Get", "List"]
      secret_permissions  = ["Get", "Set", "List"]
      storage_permissions = ["Get"]
    }

    tags = {
      environment = "dev"
    }
  }
}
mssql_servers = {
  sqlserver1 = {
    name                         = "shahed-sqlserver-01"
    resource_group_name          = "shahed-dev-01"
    location                     = "Central India"
    version                      = "12.0"
    administrator_login          = "sqladmin"
    administrator_login_password = "Admin@12345678"
    tags = {
      environment = "dev"
      owner       = "shahed"
    }
  }
}

mssql_databases = {
  db1 = {
    name            = "shaheddb1"
    server_key      = "sqlserver1"
    collation       = "SQL_Latin1_General_CP1_CI_AS"
    license_type    = "LicenseIncluded"
    max_size_gb     = 2
    sku_name        = "S0"
    enclave_type    = "VBS"
    prevent_destroy = true
    tags = {
      app = "backend"
    }
  }
}
log_analytics_workspaces = {
  backend-workspace = {
    location            = "centralindia"
    sku                 = "PerGB2018"
    retention_in_days   = 30
    resource_group_name = "shahed-dev-01"
  },
  frontend-workspace = {
    location            = "centralindia"
    sku                 = "PerGB2018"
    retention_in_days   = 60
    resource_group_name = "shahed-dev-01"
  }
}
recovery_services_vaults = {
  frontend-vault = {
    location            = "centralindia"
    resource_group_name = "shahed-dev-01"
    sku                 = "Standard"
    tags = {
      environment = "prod"
      owner       = "shahed"
    }
    vms_to_backup = [
      "/subscriptions/<SUBSCRIPTION_ID>/resourceGroups/shahed-dev-01/providers/Microsoft.Compute/virtualMachines/frontend-vm01"
    ]
  },
  backend-vault = {
    location            = "centralindia"
    resource_group_name = "shahed-dev-01"
    sku                 = "Standard"
    tags = {
      environment = "dev"
      owner       = "shahed"
    }
    vms_to_backup = [
      "/subscriptions/<SUBSCRIPTION_ID>/resourceGroups/shahed-dev-01/providers/Microsoft.Compute/virtualMachines/backend-vm01",
      "/subscriptions/<SUBSCRIPTION_ID>/resourceGroups/shahed-dev-01/providers/Microsoft.Compute/virtualMachines/backend-vm02"
    ]
  }
}
backup_policies = {
  policy1 = {
    backup_vault_name   = "frontend-vault"
    resource_group_name = "shahed-dev-01"
    schedule_policy = {
      schedule_run_frequency = "Daily"
      schedule_run_time      = "23:00"
    }
    retention_policy = {
      daily_retention_count = 30
    }
  },
  policy2 = {
    backup_vault_name   = "backend-vault"
    resource_group_name = "shahed-dev-01"
    schedule_policy = {
      schedule_run_frequency = "Daily"
      schedule_run_time      = "01:00"
    }
    retention_policy = {
      daily_retention_count = 15
    }
  }
}

key_vault_secret = {
  key_vault_name      = "shahed-kv1"
  resource_group_name = "shahed-dev-01"
  secrets = {
    "db-username" = "adminuser"
    "db-password" = "StrongPass@123"
    "storage-key" = "StorageKey123"
  }
}



shahed_lb = {
  lb1 = {
    name                      = "shahed-lb1"
    resource_group_name       = "shahed-dev-01"
    location                  = "centralindia"
    frontend_ipconfig_name    = "PublicIPAddress1"
    backend_address_pool_name = "shahed-lb1-backendpool"
    lb_probe_name             = "shahed-Health-probe1"
    protocol                  = "Tcp"
    port                      = 80
    interval_in_seconds       = 5
    lb_rule_name              = "shahed-lb1-rule"
    frontend_port             = 8080
    backend_port              = 80
    idle_timeout_in_minutes   = 4
  }
}

shahed_lb_nics = {
  lb_nic1 = {
    nic_name              = "shahed-backend-nic"
    resource_group_name   = "shahed-dev-01"
    ip_configuration_name = "internal"
    backend_pool_key      = "lb1"
  },
  # b_nic1 = {
  #   nic_name              = "shahed-backend-nic"
  #   resource_group_name   = "shahed-dev-01"
  #   ip_configuration_name = "internal"
  #   backend_pool_key      = "lb1"
  # }
}
bastion_hosts = {
  dev_bastion = {
    name                = "bastion-dev"
    location            = "Central India"
    resource_group_name = "shahed-dev-01"

    ip_configuration = {
      name                 = "bastion-ip-config-dev"
      subnet_id            = "/subscriptions/xxxx/resourceGroups/shahed-dev-01/providers/Microsoft.Network/virtualNetworks/shahed-vnet/subnets/AzureBastionSubnet"
      public_ip_address_id = "/subscriptions/xxxx/resourceGroups/shahed-dev-01/providers/Microsoft.Network/publicIPAddresses/bastion-dev-pip"
    }

    copy_paste_enabled        = true
    file_copy_enabled         = false
    sku                       = "Basic"
    ip_connect_enabled        = null
    kerberos_enabled          = null
    scale_units               = null
    shareable_link_enabled    = null
    tunneling_enabled         = null
    session_recording_enabled = null
    virtual_network_id        = null
    tags = {
      environment = "dev"
      owner       = "dev-team"
    }
    zones = []
  }
}
# Application Gateway configuration
app_gateways = {
  agw1 = {
    name                      = "shahed-agw1"
    resource_group_name       = "shahed-dev-01"
    location                  = "centralindia"
    frontend_ipconfig_name    = "agw-frontend-ip"
    backend_address_pool_name = "agw-backend-pool"
    http_listener_name        = "agw-http-listener"
    backend_http_settings_name = "agw-http-settings"
    probe_name                = "agw-health-probe"
    protocol                  = "Http"
    frontend_port             = 8080
    backend_port              = 80
    sku_name                  = "Standard_v2"
    capacity                  = 2
    request_routing_rule_name  = "agw-routing-rule"
  }
}
subnet_ids = {
  agw1 = "/subscriptions/<sub_id>/resourceGroups/<rg_name>/providers/Microsoft.Network/virtualNetworks/<vnet_name>/subnets/appgw-subnet"
}