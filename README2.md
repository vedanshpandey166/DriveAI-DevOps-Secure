🚀 DriveAI – DevOps Secure CI/CD Deployment
DriveAI is a Dockerized full-stack application deployed using a production-style DevOps CI/CD pipeline built with Jenkins, Docker, Docker Hub, and AWS EC2.
This project demonstrates real-world DevOps practices, including deploy-only pipelines, secure secret handling, container orchestration, and cloud deployment on a resource-constrained environment.

📌 Project Goals
Implement a realistic CI/CD pipeline
Avoid heavy builds on low-resource servers
Use Docker Hub as an image registry
Securely manage secrets
Deploy and run a multi-container application
Follow industry-standard DevOps architecture

📌 Architecture Overview:

Developer (Local Machine)
  |
  |-- Build Docker Images
  |-- Push Images
  v
Docker Hub (Image Registry)
  |
  |-- Jenkins pulls images
  v
Jenkins (Dockerized on AWS EC2)
  |
  |-- Checkout repository
  |-- Inject secrets (.env)
  |-- docker compose pull
  |-- docker compose up -d
  v
Docker Engine (EC2 Host)
  |
  |-- Run frontend container (Port 3000)
  |-- Run backend container (Port 8000)
  v
End Users (Browser / API Clients)


⚙️ Tech Stack
Infrastructure & DevOps:
AWS EC2 (Ubuntu, t2.micro)
Docker
Docker Compose (v2)
Jenkins (running inside Docker)
Docker Hub
GitHub

🐳 Docker Images
Backend Image:  vedansh52662/driveai-backend:latest
Frontend Image:  vedansh52662/driveai-frontend:latest


📜 Jenkins Pipeline Flow
Checkout code from GitHub
Inject secrets using Jenkins Credentials
Create .env file at runtime
Pull images from Docker Hub
Deploy containers using Docker Compose


🔐 Secrets Management

Secrets are stored in Jenkins Credentials
Injected dynamically during deployment
.env file is never committed to Git
Follows DevOps security best practices


🚀 Deployment
Jenkins UI: http://<EC2-PUBLIC-IP>:8080


🚀 Complete Run Steps
🔹 Step 1: Clone the Repository
git clone https://github.com/vedanshpandey166/DriveAI-DevOps-Secure.git
cd DriveAI-DevOps-Secure

🔹 Step 2: (Optional) Build & Push Docker Images (Skip this step as images already exist on Docker Hub)
docker build -t driveai-backend -f docker/backend/Dockerfile .
docker tag driveai-backend vedansh52662/driveai-backend:latest

docker build -t driveai-frontend -f docker/frontend/Dockerfile .
docker tag driveai-frontend vedansh52662/driveai-frontend:latest

🔹 Login and push:
docker login
docker push vedansh52662/driveai-backend:latest
docker push vedansh52662/driveai-frontend:latest


🔹 Step 3: Launch EC2 Instance 
"terraform apply -auto-approve"
OS: Ubuntu 20.04 / 22.04
Instance type: t2.micro
Open ports:
8080, 3000, 8000


Step 4: SSH into EC2 ( go into terraform folder)
ssh -i keys/driveai-key ubuntu@<EC2_PUBLIC_IP>


🔹 Step 4: Start Jenkins (Dockerized) ( on ec2 go to jenkins folder)
docker compose up -d

Get admin password:
docker exec -it jenkins cat /var/jenkins_home/secrets/initialAdminPassword

Access Jenkins: http://<EC2-PUBLIC-IP>:8080


🔹 Step 5: Configure Jenkins Pipeline

Create Pipeline Job
Name: driveai-ci-cd
SCM → Git
Repository URL:
https://github.com/vedanshpandey166/DriveAI-DevOps-Secure.git

Branch:
*/main

Script Path:
jenkins/Jenkinsfile

Save.

🔹 Step 6: Add Secrets in Jenkins
Manage Jenkins → Credentials → Global
Add:
Kind: Secret Text
ID: GROQ_API_KEY
Value: <your-secret-key>

🔹 Step 7: Deploy the Application
In Jenkins:
Open job driveai-ci-cd
Click Build Now

Jenkins will:
Checkout repo
Inject secrets
Pull images from Docker Hub
Deploy containers using Docker Compose

🔹 Step 8: Verify Deployment
On EC2:
docker ps

🔹 Step 9: Access Services
Jenkins:
http://<EC2-PUBLIC-IP>:8080

Backend (Swagger):
http://<EC2-PUBLIC-IP>:8000/docs

Frontend:
http://<EC2-PUBLIC-IP>:3000
