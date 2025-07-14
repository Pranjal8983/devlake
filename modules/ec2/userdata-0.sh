#!/bin/bash
sudo su
yum update -y
amazon-linux-extras enable docker
yum install -y docker
yum ibstall -y
yum install git -y
service docker start
systemctl enable docker
mkdir -p ~/.docker/cli-plugins
curl -SL https://github.com/docker/compose/releases/latest/download/docker-compose-linux-x86_64 -o ~/.docker/cli-plugins/docker-compose
chmod +x ~/.docker/cli-plugins/docker-compose
git clone https://github.com/merico-dev/lake.git devlake-setup
cd devlake-setup
cp -arp devops/releases/lake-v0.21.0/docker-compose.yml ./
cp env.example .env
echo "ENCRYPTION_SECRET=password123" >> .env
mv docker-compose-dev.yml compose.yml
docker compose up -d
docker ps
