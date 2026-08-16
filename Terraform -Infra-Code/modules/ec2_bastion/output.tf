output "bastion_public_ip" { value = aws_instance.bastion.public_ip }
output "bastion_instance_id" { value = aws_instance.bastion.id }
output "bastion_iam_role_arn" { value = aws_iam_role.bastion_admin_role.arn }