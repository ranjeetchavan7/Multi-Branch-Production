variable "cluster_name" { type = string }
variable "cluster_version" { type = string }
variable "vpc_id" { type = string }
variable "private_subnet_ids" { type = list(string) }
variable "bastion_sg_id" { type = string }
variable "bastion_iam_role_arn" { type = string }
variable "tags" { type = map(string) }