output "bastion_sg_id" { value = aws_security_group.bastion_sg.id }
output "eks_additional_sg_id" { value = aws_security_group.eks_additional_sg.id }