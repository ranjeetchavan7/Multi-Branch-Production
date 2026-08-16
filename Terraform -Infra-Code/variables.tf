variable "aws_region" {
  type    = string
  default = "ap-south-1"
}

variable "environment" {
  type    = string
  default = "dev"
}

variable "key_name" {
  description = "DevOps-Project.pem"
  type        = string
}

variable "vpc_cidr" {
  type    = string
  default = "10.0.0.0/16"
}

variable "availability_zones" {
  type    = list(string)
  default = ["ap-south-1a", "ap-south-1b"]
}

variable "public_subnets" {
  type    = list(string)
  default = ["10.0.1.0/24", "10.0.2.0/24"]
}

variable "private_subnets" {
  type    = list(string)
  default = ["10.0.10.0/24", "10.0.20.0/24"]
}

variable "allowed_ssh_cidrs" {
  description = "IP CIDR allowed to SSH into Bastion"
  type        = list(string)
  default     = ["0.0.0.0/0"]
}

variable "tags" {
  type = map(string)
  default = {
    Environment = "prod"
    ManagedBy   = "Terraform"
  }
}