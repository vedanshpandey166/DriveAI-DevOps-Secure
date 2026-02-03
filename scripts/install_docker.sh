#!/bin/bash
set -euxo pipefail

export DEBIAN_FRONTEND=noninteractive
LOG_FILE="/var/log/docker-install.log"

echo "Starting Docker installation on Ubuntu..." | tee -a $LOG_FILE

# Wait for cloud-init and apt lock
sleep 30

# Update system
apt-get update -y | tee -a $LOG_FILE

# Install Docker
apt-get install -y docker.io | tee -a $LOG_FILE

# Start and enable Docker
systemctl start docker
systemctl enable docker

# Add ubuntu user to docker group
usermod -aG docker ubuntu

# Install Docker Compose (v2 plugin)
DOCKER_COMPOSE_VERSION="v2.25.0"
mkdir -p /usr/local/lib/docker/cli-plugins

curl -SL https://github.com/docker/compose/releases/download/${DOCKER_COMPOSE_VERSION}/docker-compose-linux-x86_64 \
  -o /usr/local/lib/docker/cli-plugins/docker-compose

chmod +x /usr/local/lib/docker/cli-plugins/docker-compose

echo "Docker and Docker Compose installed successfully on Ubuntu." | tee -a $LOG_FILE
