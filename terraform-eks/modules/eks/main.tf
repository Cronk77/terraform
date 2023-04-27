# EKS Cluster
resource "aws_eks_cluster" "this" {
  name     = "${var.project}-${var.version_name}-cluster"
  role_arn = aws_iam_role.cluster.arn
  version  = var.eks_version
  # version  = "1.24"

  vpc_config {
    # security_group_ids      = [aws_security_group.eks_cluster.id, aws_security_group.eks_nodes.id]
    subnet_ids              = flatten([var.public_subnets, var.public_subnets])
    endpoint_private_access = true
    endpoint_public_access  = true
    public_access_cidrs     = ["0.0.0.0/0"]
  }

  tags = merge(
    var.tags
  )

  depends_on = [
    aws_iam_role_policy_attachment.cluster_AmazonEKSClusterPolicy
  ]
}


# EKS Cluster IAM Role
resource "aws_iam_role" "cluster" {
  name = "${var.project}-${var.version_name}-Cluster-Role"

  assume_role_policy = <<POLICY
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "Service": "eks.amazonaws.com"
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
POLICY
}

resource "aws_iam_role_policy_attachment" "cluster_AmazonEKSClusterPolicy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSClusterPolicy"
  role       = aws_iam_role.cluster.name
}


# EKS Cluster Security Group
resource "aws_security_group" "eks_cluster" {
  name        = "${var.project}-${var.version_name}-cluster-sg"
  description = "Cluster communication with worker nodes"
  vpc_id      = var.vpc_id # aws_vpc.this.id

  tags = {
    Name = "${var.project}-${var.version_name}-cluster-sg"
  }
}

resource "aws_security_group_rule" "cluster_inbound" {
  description              = "Allow worker nodes to communicate with the cluster API Server"
  from_port                = 0 # 443
  protocol                 = "-1" # "tcp"
  security_group_id        = aws_security_group.eks_cluster.id
  source_security_group_id = var.nodes_sg #   aws_security_group.eks_nodes.id
  to_port                  =  65535 # 443
  type                     = "ingress"
}

resource "aws_security_group_rule" "cluster_outbound" {
  description              = "Allow cluster API Server to communicate with the worker nodes"
  from_port                = 0 # 1024
  protocol                 = "-1" # "tcp"
  security_group_id        = aws_security_group.eks_cluster.id
  source_security_group_id = var.nodes_sg ###########   aws_security_group.eks_nodes.id
  to_port                  = 65535
  type                     = "egress"
}