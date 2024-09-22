# AWS EKS Cluster with Managed Node Group and ALB Ingress Controller using Terraform

This repository contains Terraform code to provision an Amazon EKS (Elastic Kubernetes Service) cluster with a managed node group and deploy the AWS ALB (Application Load Balancer) Ingress Controller.

## Prerequisites

Ensure you have the following installed and configured before proceeding:

- [Terraform](https://www.terraform.io/)
- [AWS CLI](https://aws.amazon.com/cli/) (configured with appropriate credentials)
- [kubectl](https://kubernetes.io/docs/tasks/tools/)
- [AWS IAM Authenticator for Kubernetes](https://docs.aws.amazon.com/eks/latest/userguide/install-aws-iam-authenticator.html)
- [Helm](https://helm.sh/)

## Setup Instructions

### 1. Clone the Repository

```shell
git clone https://github.com/corresponds/eks-alb-helm-terraform.git
cd eks-alb-helm-terraform
```

### 2. Configure and Apply Terraform

Make sure to customize the Terraform variables as needed for your environment. Then, apply the configuration:

```shell
terraform init
terraform apply
```

### 3. Configure `kubectl` to Connect to EKS

Once the EKS cluster is provisioned, update your local kubeconfig file to interact with the cluster:

```shell
aws eks update-kubeconfig --name eks-cluster --region us-east-1
kubectl get nodes
```

Open main.tf, Change to your account id `<YourAccountId>`
```hcl
resource "aws_iam_policy_attachment" "example_policy_attachment" {
  name       = "load-balancer-controller-policy-attachment"
  policy_arn = "arn:aws:iam::<YourAccountId>:policy/AWSLoadBalancerControllerIAMPolicy"
  roles      = [aws_iam_role.example_role.name]
}
```

Open backend.tf change S3 bucket name.

### 4. Install NGINX Ingress Controller using Helm

Add the official NGINX Ingress Controller Helm repository and install the controller:

```shell
helm repo add ingress-nginx https://kubernetes.github.io/ingress-nginx
helm repo update
helm install my-nginx-ingress ingress-nginx/ingress-nginx
```

Verify the installation by checking the status of the pods and services:

```shell
kubectl get pods -n default
kubectl get svc my-nginx-ingress-ingress-nginx-controller
```

### 5. Deploy the Application

Apply the Kubernetes manifests for your application (Deployment, Service, and Ingress) found in the `kube` directory:

```shell
kubectl apply -f kube/deployment.yaml 
kubectl apply -f kube/service.yaml 
kubectl apply -f kube/ingress.yaml
```

### 6. Access the Application

Retrieve the external IP of the Ingress Controller and access the application:

```shell
kubectl get svc -n default
curl http://<EXTERNAL-IP>
```

### 7. Clean Up Resources

When you're done, clean up the deployed resources and uninstall the Ingress Controller:

```shell
kubectl delete -f kube/deployment.yaml 
kubectl delete -f kube/service.yaml 
kubectl delete -f kube/ingress.yaml
helm uninstall my-nginx-ingress
```

### 8. Reference cmd

```shell
helm repo remove eks
kubectl apply -k "github.com/aws/eks-charts/stable/aws-load-balancer-controller//crds?ref=master"
helm upgrade -i aws-load-balancer-controller eks/aws-load-balancer-controller -n kube-system --set clusterName=eks-cluster --set serviceAccount.create=false --set serviceAccount.name=alb-ingress-controller
```

### Notes
Your contributions are welcome! If you find any issues or have suggestions, please open an [issue](https://github.com/corresponds/gekas/issues) or PR
- How to PR
  - Fork the repository 
  - Create a new branch
  - Commit code changes
  - Submit a Pull Request (PR)
