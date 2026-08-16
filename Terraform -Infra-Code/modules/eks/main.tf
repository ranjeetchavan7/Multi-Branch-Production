module "eks" {
  source  = "terraform-aws-modules/eks/aws"
  version = "~> 20.0"

  cluster_name    = var.cluster_name
  cluster_version = var.cluster_version

  vpc_id                          = var.vpc_id
  subnet_ids                      = var.private_subnet_ids
  cluster_endpoint_public_access  = true
  cluster_endpoint_private_access = true

  enable_cluster_creator_admin_permissions = true

  # 1. Allow Bastion Host to reach the EKS Control Plane API (Port 443)
  cluster_security_group_additional_rules = {
    ingress_from_bastion = {
      description              = "Allow Bastion SG to talk to EKS API"
      protocol                 = "tcp"
      from_port                = 443
      to_port                  = 443
      type                     = "ingress"
      source_security_group_id = var.bastion_sg_id
    }
  }

  # 2. Allow Bastion Host to talk to Worker Nodes
  node_security_group_additional_rules = {
    ingress_from_bastion = {
      description              = "Allow traffic from Bastion SG"
      protocol                 = "-1"
      from_port                = 0
      to_port                  = 0
      type                     = "ingress"
      source_security_group_id = var.bastion_sg_id
    }
  }

  access_entries = {
    bastion_admin = {
      principal_arn = var.bastion_iam_role_arn

      policy_associations = {
        admin = {
          policy_arn = "arn:aws:eks::aws:cluster-access-policy/AmazonEKSClusterAdminPolicy"
          access_scope = {
            type = "cluster"
          }
        }
      }
    }
  }

  eks_managed_node_groups = {
    default = {
      name           = "default-ng"
      instance_types = ["t3.medium"]
      min_size       = 1
      max_size       = 3
      desired_size   = 2
    }
  }

  tags = var.tags
}