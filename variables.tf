variable "location" {
  description = "Azure region"
  default     = "South Africa North"
}

variable "resource_prefix" {
  description = "Prefix for all resources"
  default     = "epicbook-prod"
}

variable "vm_size" {
  description = "Azure VM size"
  default     = "Standard_B2ats_v2"
}

variable "admin_username" {
  description = "VM admin username"
  default     = "ubuntu"
}

variable "admin_password" {
  description = "VM admin password"
  sensitive   = true
}

variable "db_name" {
  description = "Database name"
  default     = "bookstore"
}

variable "db_user" {
  description = "Database admin username"
  default     = "epicbook_user"
}

variable "db_password" {
  description = "MySQL database password"
  sensitive   = true
}