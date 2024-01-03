#! bin/bash

sudo yum update -y && sum yum install -y docker
sudo systemctrl start docker
sudo usermod -aG docker ec2-user