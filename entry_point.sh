#! bin/bash

sudo yum update -y && yum yum install -y docker
sudo systemctrl start docker
sudo usermod -aG docker ec2-user

docker run -p 8080:80 nginx