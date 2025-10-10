# Jenkins-EKS-terraform
Project built with Jenkins → Terraform → AWS EKS CI/CD pipeline that runs on an EC2-hosted Jenkins master, provisions EKS clusters with Terraform, and pulls application directories from a GitHub repo to deploy to the cluster.


**A — Architecture overview**

Simple flow:

 - I pushes the code to GitHub (repo contains Terraform and app manifests or separate repo(s)).

 - Jenkins (running on an EC2 instance) picks up the change (via webhook or polling).

 - Jenkins pipeline:

    > checks out repo,

    > runs Terraform (init, plan, apply) to create/update VPC, EKS, node groups, IAM, etc.

    > generates/updates kubeconfig (using aws eks update-kubeconfig or Terraform output),

    > deploys application manifests/Helm charts to EKS (kubectl/helm).

  - Terraform stores state in S3 with DynamoDB for locking.

  - EKS worker nodes run on EC2 node groups (managed or self-managed).

**Components:**

1. Jenkins Master (EC2)

2. Terraform code (module-based, e.g., terraform-aws-modules/eks/aws)

3. AWS: VPC, subnets, EKS control plane, node groups, IAM roles

4. State backend: S3 + DynamoDB

5. GitHub repo(s)

6. Secrets/Credentials stored in Jenkins Credentials (or use instance profile + IRSA)


**B — Prerequisites & accounts**

  - AWS account with permission to create: VPC, EC2, IAM, EKS, S3, DynamoDB, CloudWatch, ELB.

  - An EC2 instance for Jenkins (Ubuntu 22.04 recommended) with:

  - Instance profile (IAM role) giving Jenkins rights OR Jenkins will use AWS access key/secret (less recommended).

  - A GitHub repo with:

    > Terraform code (or Terraform in separate infra repo)

    > Kubernetes manifests / Helm charts (app repo)

    > DNS (optional) and TLS (optional)

    > Local machine with kubectl, terraform for local testing (optional)



**C — Jenkins on EC2 (setup)**
 - EC2 instance

   - Ubuntu 22.04 LTS, t3.medium or bigger depending on load.

   - Give it an Instance Role with policy to access S3, DynamoDB, EKS, EC2, IAM (or limit as appropriate).

   - Security group: open SSH (your IP), HTTP/HTTPS if you expose Jenkins, and port 8080.

   
**D - Jenkins Plugins to install**
 - Pipeline

 - Git

 > Credentials

   - AWS Steps / Amazon EC2 / Amazon ECR (optional)

   - Kubernetes CI/CD (optional)

   - Terraform / HashiCorp Vault (if used)

   - SSH Agent (if using SSH keys)

   - Blue Ocean (optional)

 > Jenkins credentials

   - Add AWS credentials (if not using instance profile): AWS IAM user access key / secret.

 > Add GitHub credentials:

   - Prefer SSH key stored as SSH Username with private key credential and add public key to GitHub deploy keys, or

   - Use GitHub App / Personal Access Token stored as Secret text.

   - Add any other secrets (TLS, Docker registry, helm repository credentials).