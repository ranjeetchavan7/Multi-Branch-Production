output "bastion_public_ip" {
  description = "Public IP address of the Bastion EC2 instance"
  value       = module.ec2_bastion.bastion_public_ip
}

output "eks_cluster_name" {
  description = "EKS Cluster Name"
  value       = module.eks.cluster_name
}

output "eks_cluster_endpoint" {
  description = "EKS Control Plane Endpoint"
  value       = module.eks.cluster_endpoint
}