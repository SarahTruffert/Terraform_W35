resource "azurerm_app_service_plan" "app_service_plan" {
  name                = "ASP-PartyAdvisor-bddc"
  location            = var.location
  resource_group_name = var.rg_name

  sku {
    tier = "PremiumV2"
    size = "P2v2"
  }
}


resource "azurerm_app_service" "app_service_principal" {
  name                = "PartyAdvisorSimplon"
  location            = var.location
  resource_group_name = var.rg_name
  app_service_plan_id = azurerm_app_service_plan.app_service_plan.id

  app_settings = {
      "LOGINVM" = var.LOGINVM
      "PWDVM" = var.PWDVM
      "LOGINDB" = var.LOGINDB
      "PWDDB" = var.PWDDB 
    }

  connection_string {
    name  = "DefaultConnection"
    type  = "SQLServer"
    value = "Server=PartyAdvisorSrv.database.windows.net,1433;Initial Catalog=PartyAdvisorDb;Persist Security Info=False;User ID=${var.LOGINDB};Password=${var.PWDDB};MultipleActiveResultSets=False;Encrypt=True;TrustServerCertificate=False;Connection Timeout=30;"
  }

  depends_on = [
    azurerm_sql_server.sql_server,
    azurerm_sql_database.database
  ]
}