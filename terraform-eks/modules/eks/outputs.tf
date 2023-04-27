output "cluster_id" {
    value = aws_eks_cluster.this.id
}

output "cluster_name" {
    value = aws_eks_cluster.this.name
}

output "cluster_sg" {
    value = aws_security_group.eks_cluster.id
}