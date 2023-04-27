To access EKS use this command

aws eks update-kubeconfig --region us-east-2 --name cc-aline-project-eks-cluster

common kubectl commands:
kubectl get pods
kubectl get svc         (services)
kubectl logs <pod id>