output "public_ip_address" {
    value  = [data.azurerm_public_ips.public_ips.public_ips]
}