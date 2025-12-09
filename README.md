# 🚀 AWS DevOps Pipeline — Full CI/CD with Jenkins, Terraform, ECS Fargate & ALB

This project demonstrates a **production-grade DevOps pipeline** built on AWS, using:

- **Jenkins** (CI/CD automation running in Docker on EC2)
- **Terraform** (IaC for AWS provisioning)
- **Amazon ECR** (container registry)
- **Amazon ECS Fargate** (container orchestration)
- **Application Load Balancer (ALB)** (traffic routing)
- **Docker** (containerization of frontend + backend apps)
- **GitHub** (source control + pipeline triggers)

The pipeline automatically:

1. Pulls code from GitHub  
2. Builds Docker images for both frontend (React + NGINX) and backend (Node/Express)  
3. Tags & pushes images to Amazon ECR  
4. Executes `terraform apply` to deploy new versions to ECS Fargate  
5. Updates ALB target groups with healthy running containers  

This is a **portfolio-quality project** demonstrating Cloud Engineering, DevOps, CI/CD, IaC, containerization, and AWS infrastructure design.

---

## 🏗️ **Architecture Overview**

```text
GitHub → Jenkins (EC2 + Docker) → ECR → Terraform → ECS Fargate → ALB → Users

---

Flow Breakdown:
- Developer pushes code → GitHub triggers Jenkins.
- Jenkins builds Docker images, pushes to ECR.
- Jenkins runs Terraform to update ECS task definitions.
- ECS pulls images from ECR and deploys new tasks.
- ALB routes traffic to healthy frontend + backend tasks.

---

📦 Technologies Used
🛠 DevOps & CI/CD
- Jenkins (Pipeline-as-Code)
- Docker
- SSH + GitHub Integration

☁️ AWS Infrastructure
- ECS Fargate
- ECR
- Application Load Balancer (ALB)
- VPC (subnets, route tables, SGs)
- IAM Roles
- CloudWatch (optional logs)

⚙️ IaC
- Terraform (v1.x)
- terraform-aws-vpc module

💻 Application Stack
- Frontend: React → built → served by NGINX
- Backend: Node.js / Express
- Dockerized microservices

---

📁 Project Structure
.
├── backend/
│   ├── Dockerfile
│   ├── package.json
│   └── src/...
├── frontend/
│   ├── Dockerfile
│   ├── package.json
│   └── src/...
├── infra/
│   ├── main.tf
│   ├── variables.tf
│   ├── outputs.tf
├── Jenkinsfile
└── README.md

---

🚀 Deployment Pipeline (Jenkinsfile Summary)

The pipeline:
1. Checks out code
2. Logs into Amazon ECR
3. Builds Docker images
4. Tags & pushes images to ECR
5. Runs Terraform
6. Deploys to ECS

Snippet:
stage('Deploy to ECS via Terraform') {
    steps {
        withAWS(credentials: 'aws-devops-creds', region: "${AWS_REGION}") {
            dir('infra') {
                sh '''
                    terraform init -input=false
                    terraform apply -auto-approve \
                      -var="backend_image=$BACKEND_REPO:latest" \
                      -var="frontend_image=$FRONTEND_REPO:latest"
                '''
            }
        }
    }
}

---

🌐 Accessing the App

After deployment, Terraform outputs:

    alb_dns_name = http://<alb-generated-dns>

Front-end loads at the root path:

    http://<ALB_DNS>

Backend reachable at:

    http://<ALB_DNS>/api/

---

🧪 Local Development

Backend:

    cd backend
    npm install
    npm start

Frontend:

    cd frontend
    npm install
    npm start

---

⚠️ TEARDOWN GUIDE (Prevent Extra AWS Charges)

When you’re done using this project YOU MUST TEARDOWN ALL RESOURCES, otherwise AWS will continue billing you for:
- ECS Fargate tasks
- ALB hourly charges
- EC2 instance running Jenkins
- ECR image storage
- VPC resources

🛑 STEP 1 — Destroy Terraform Infrastructure

From your laptop or local machine:

    cd infra

    terraform destroy \
    -var="backend_image=<your-backend-ecr-uri>:latest" \
    -var="frontend_image=<your-frontend-ecr-uri>:latest"


Confirm with yes when prompted.

This deletes:
- ECS cluster
- Task definitions
- Services
- ALB + listeners + target groups
- VPC & subnets
- IAM roles created by Terraform

---

🛑 STEP 2 — Terminate Jenkins EC2 Server

In AWS console:
1. Go to EC2 → Instances
2. Select your jenkins-server
3. Click Instance state → Terminate
4. Confirm termination

This stops:
- EC2 hourly billing
- EBS volume charges

---

🛑 STEP 3 — Delete ECR Repositories (Optional)

If you no longer need the images:

    aws ecr delete-repository --repository-name devops-backend --force --region us-east-1
    aws ecr delete-repository --repository-name devops-frontend --force --region us-east-1


--force removes images inside.

---

🛑 STEP 4 — Delete Unused IAM Roles (If Not Managed by Terraform)

Go to:
AWS Console → IAM → Roles

Delete roles created manually (but keep AWS service roles).

---

🛑 STEP 5 — Release Elastic IP (Optional)

If you want to avoid charges
1. EC2 → Elastic IPs
2. Select the EIP used by Jenkins
3. Click Release Elastic IP

---

🎉 Final Result

You have built a full production-grade CI/CD system:
- Automated build + deployment pipeline
- ECS microservices architecture
- ALB routing with health checks
- Infrastructure-as-Code through Terraform
- Dockerized modern application

This project is now portfolio-ready and interview-ready.