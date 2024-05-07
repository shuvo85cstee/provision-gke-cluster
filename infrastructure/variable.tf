variable "region" {
  type = string
}

variable "ip_cidr_range" {
  type = string
}

variable "location" {
  type = string
}

variable "project_id" {
  type = string
}

variable "jump_internal_ip" {
  type = string
}

variable "ssh_key_private" {
  description = "Path to the private key used to access instances via ssh"
  type        = string
  default     = "/Users/iftekhar.hossen/.ssh/id_ed25519.pub"
}

variable "playbook_path" {
  description = "Path to ansible playbook to be executed with the created host as inventory"
  type        = string
  default     = "files/playbook.yml"
}