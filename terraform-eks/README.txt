This Project is to simulate conducting a deployment strategies by standing up 
two seperate eks clusters within their own respective VPC's, while sharing a 
common RDS.

The process of completing this is as follows:

*   Create the RDS by doing into the solo-rds directory and running terraform init and apply
*   Then we stand up the blue EKS cluster which has an endpoint to hit by and ELB, and can be stood up
    by going into eks-blue directory and executing terraform init and apply commands.
*   Next we do somthing similar with Standing up the Greeen version as the newer version of the EKS
*   This next part requires you to have a route53 hosted zone set up. I set one up with a 3rd party 
    domain name provider, but doing the provisioning a name through aws might be just as easy. 
*   There is a folder called route53_blue and route53_green. you must give the state file name for the 2
    clusters to be able to pick up the elb's host to route the route53 towards them with records
    and weights. This way you can design how much traffic you want to go to each cluster based on
    percentages. 

##################################################################################################
To Simulate the Blue green Deployment. You can use this command while inside the ansible directory. 
ansible-playbook -i hosts playbooks/blue-green-deployment/simulate_blue_green_deployment.yaml -v

To Simulate the Canary Deployment. You can use this command while inside the ansible directory. 
ansible-playbook -i hosts playbooks/canary-deployment/simulated-canary-deployment.yaml -v

Clean up all resources. You can do this using this command:
ansible-playbook -i hosts playbooks/stand-down/delete-all.yaml -v

    
##################################################################################################
To access EKS use this command

aws eks update-kubeconfig --region us-east-2 --name cc-aline-project-eks-blue-cluster
aws eks update-kubeconfig --region us-east-2 --name cc-aline-project-eks-green-cluster

common kubectl commands:
kubectl get pods
kubectl get svc         (services)
kubectl logs <pod id>
kubectl describe pods <pod id>
kubectl describe svc <svc id>

    * NOTE: You can check where traffic is going by signing into the clusters via kubectl and 
            checking the logs to see where it's going. 

##################################################################################################
For future Deployements and updates. You only need to change the ansible group vars for blue_dir and
green_dir to be the location of the current/old (blue) cluster project and the update/new (green) 
project. This will make the playbooks to conduct the changes automatically with minor changes. 