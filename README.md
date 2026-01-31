🚀 Project: Jenkins Server on AWS using Terraform, Docker Compose & GitHub
🎯 Goal
Provision a fully automated Jenkins server on AWS using modular Terraform, deploy Jenkins using Docker Compose from a GitHub repo, assign an Elastic IP, and enable daily EBS snapshots with data persistence.
________________________________________
🧱 Infrastructure Provisioned (Terraform – Modular)
You created reusable modules for:
•	VPC (subnet, route table, IGW)
•	Security Group (22, 8080 open)
•	EC2 Instance
o	Amazon Linux 2023
o	20 GB EBS root volume (gp3)
o	Elastic IP attached
o	Userdata for automated setup
•	IAM + AWS DLM
o	Automated daily EBS snapshots
o	Retention policy
All wired through a root main.tf using variables and tfvars.
________________________________________
🐳 Jenkins Deployment (Docker Compose from GitHub)
Instead of installing Jenkins manually:
•	Created a GitHub repo with docker-compose.yml
•	EC2 userdata:
o	Installs Docker
o	Installs Docker Compose
o	Clones GitHub repo
o	Runs docker-compose up -d
This means Jenkins can be recreated anytime from code.
________________________________________
💾 Data Persistence (Critical Requirement)
Verified using:
docker volume ls
docker volume inspect jenkins-docker-compose_jenkins_data
Confirmed Jenkins data stored in:
/var/lib/docker/volumes/.../_data
Contains:
jobs, plugins, users, secrets, config.xml
Container can be removed → data still safe.
________________________________________
🌍 Access
Jenkins accessible via:
http://Elastic-IP:8080
________________________________________
🔁 EBS Snapshots (Disaster Recovery)
Using AWS Data Lifecycle Manager via Terraform:
•	Snapshot every 24 hours
•	Retain last 7 snapshots
•	Tagged to Jenkins volume
________________________________________
🗣️ How you explain this in interview (short)
“I provisioned a modular AWS infrastructure using Terraform to host Jenkins on EC2 with an Elastic IP. Jenkins is deployed via Docker Compose pulled from GitHub with persistent Docker volumes. I also implemented automated daily EBS snapshots using AWS DLM for backup and recovery.”
