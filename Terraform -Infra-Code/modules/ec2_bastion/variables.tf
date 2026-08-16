variable "environment" { type = string }
variable "instance_type" {
  type    = string
  default = "t2.large"
}
variable "key_name" {
  description = "DevOps-Project.pem"
  type        = string
}
variable "public_subnet_id" { type = string }
variable "bastion_sg_id" { type = string }
variable "tags" { type = map(string) }