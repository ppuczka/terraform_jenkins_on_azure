output "docker_host_public_ip" { 
    value = azure_rm_public_ip.ip-2.ip_address
}

output "jenkins_host_public_ip" {
    value = azure_rm_public_ip.ip-1.ip_address
}
