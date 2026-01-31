#!/bin/bash
set -eux

yum update -y
yum install -y docker git

systemctl enable docker
systemctl start docker

# Install Docker Compose
curl -L https://github.com/docker/compose/releases/latest/download/docker-compose-linux-x86_64 -o /usr/local/bin/docker-compose
chmod +x /usr/local/bin/docker-compose

usermod -aG docker ec2-user

# Clone repo as ec2-user
sudo -u ec2-user git clone "REPO_PLACEHOLDER" /home/ec2-user/jenkins-docker-compose

# Give Docker some time
sleep 40

# Start Jenkins using full path (no group issue)
cd /home/ec2-user/jenkins-docker-compose
/usr/local/bin/docker-compose up -d
