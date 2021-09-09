resource "azurerm_sql_server" "sql_server" {
  name                         = "partyadvisorsrv"
  resource_group_name          = var.rg_name
  location                     = var.location
  version                      = "12.0"
  administrator_login          = var.LOGINDB
  administrator_login_password = var.PWDDB
}

resource "azurerm_sql_database" "database" {
  name                = "PartyAdvisorDb"
  resource_group_name = var.rg_name
  location            = var.location
  server_name         = azurerm_sql_server.sql_server.name
}