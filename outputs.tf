output "docker_host_public_ip" { 
    value = azurerm_public_ip.ip-2.ip_address
}

output "jenkins_host_public_ip" {
    value = azurerm_public_ip.ip-1.ip_address
}
