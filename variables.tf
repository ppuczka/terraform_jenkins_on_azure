variable "rg_name" {
  description = "resource group name"
  default     = "DevOps_Lab"
}

variable "location" {
  description = "location name"
  default     = "West Europe"
}

variable "vnet_name" {
  default = "DevOps_vnet"
}

variable "address_space" {
  default = ["10.0.0.0/16"]
}

variable "subnet_name" {
  default = "public_subnet"
}

variable "address_prefix" {
  default = "10.0.1.0/24"
}
# Define number of virutal machines to be created
variable "numbercount" {
  type    = number
  default = 1
}

variable "external_ip" {
  type    = list(string)
  default = ["83.30.194.6"]
}

variable "environment" {
  default = "Development"
}

variable "subscription" {
  description = "Azure secret subscription id"
}

variable "tenant" {
  description = "Azure secret tenant id"
}

variable "ARM_ACCES_KEY" {
  description = "Azure storage container key"
}

