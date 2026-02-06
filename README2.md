🚀 DriveAI – DevOps Secure CI/CD Deployment

DriveAI is a Dockerized full-stack application deployed using a production-style DevOps CI/CD pipeline built with Jenkins, Docker, Docker Hub, and AWS EC2.

This project demonstrates real-world DevOps practices including deploy-only pipelines, secure secret handling, container orchestration, and cloud deployment on a resource-constrained environment (t2.micro).

📌 Project Goals

Implement a realistic CI/CD pipeline

Avoid heavy builds on low-resource servers

Use Docker Hub as a centralized image registry

Securely manage secrets

Deploy and run a multi-container application

Follow industry-standard DevOps architecture

📌 Architecture Overview

Developer → Docker Hub → Jenkins (EC2) → Docker Compose → Frontend (3000) + Backend (8000) → Users

⚙️ Tech Stack

Infrastructure & DevOps

AWS EC2 (Ubuntu 20.04 / 22.04 – t2.micro)

Docker

Docker Compose (v2)

Jenkins (running inside Docker)

Docker Hub

GitHub

🐳 Docker Images
Backend Image  : vedansh52662/driveai-backend:latest
Frontend Image : vedansh52662/driveai-frontend:latest


Images are pre-built and stored in Docker Hub to keep CI lightweight.

📜 Jenkins Pipeline Flow

Checkout code from GitHub

Inject secrets using Jenkins Credentials

Create .env file at runtime

Pull Docker images from Docker Hub

Deploy containers using Docker Compose

🔐 Secrets Management

Secrets are stored securely in Jenkins Credentials

Injected dynamically during deployment

.env file is never committed to GitHub

Follows DevOps security best practices

🚀 Jenkins Access
http://<EC2-PUBLIC-IP>:8080

🚀 Complete Run Steps (For Anyone Cloning This Repo)
🔹 Step 1: Clone the Repository

git clone https://github.com/vedanshpandey166/DriveAI-DevOps-Secure.git
cd DriveAI-DevOps-Secure

🔹 Step 2: (Optional) Build & Push Docker Images

⚠️ Skip this step — images already exist on Docker Hub
Use only if you modify backend/frontend code.

# Backend
docker build -t driveai-backend -f docker/backend/Dockerfile .
docker tag driveai-backend vedansh52662/driveai-backend:latest

# Frontend
docker build -t driveai-frontend -f docker/frontend/Dockerfile .
docker tag driveai-frontend vedansh52662/driveai-frontend:latest


Login and push:

docker login
docker push vedansh52662/driveai-backend:latest
docker push vedansh52662/driveai-frontend:latest

🔹 Step 3: Launch EC2 Using Terraform
terraform apply -auto-approve


EC2 Requirements:

OS: Ubuntu 20.04 / 22.04

Instance Type: t2.micro

Open Ports:

8080 (Jenkins)

3000 (Frontend)

8000 (Backend)

🔹 Step 4: SSH into EC2

(from terraform directory)

ssh -i keys/driveai-key ubuntu@<EC2_PUBLIC_IP>

🔹 Step 5: Start Jenkins (Dockerized)
cd jenkins
docker compose up -d


Get Jenkins admin password:

docker exec -it jenkins cat /var/jenkins_home/secrets/initialAdminPassword


Access Jenkins:

http://<EC2-PUBLIC-IP>:8080

🔹 Step 6: Configure Jenkins Pipeline

Create Pipeline Job

Job Name: driveai-ci-cd

Pipeline Configuration:

SCM → Git

Repository URL:

https://github.com/vedanshpandey166/DriveAI-DevOps-Secure.git


Branch:

*/main


Script Path:

jenkins/Jenkinsfile


Click Save.

🔹 Step 7: Add Secrets in Jenkins

Navigate to:

Manage Jenkins → Credentials → Global


Add:

Kind: Secret Text

ID: GROQ_API_KEY

Value: <your-secret-key>

🔹 Step 8: Deploy the Application

In Jenkins:

Open job driveai-ci-cd

Click Build Now

Jenkins will:

Checkout repository

Inject secrets

Pull images from Docker Hub

Deploy containers using Docker Compose

🔹 Step 9: Verify Deployment (On EC2)
docker ps

🔹 Step 10: Access Services

Jenkins

http://<EC2-PUBLIC-IP>:8080


Backend (Swagger UI)

http://<EC2-PUBLIC-IP>:8000/docs


Frontend

http://<EC2-PUBLIC-IP>:3000
