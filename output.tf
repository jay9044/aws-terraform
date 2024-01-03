output "aws_ami" {
  value = module.webserver_creation.ami
}

output "ec2_public_dns" {
  value = module.webserver_creation.webserver.public_dns
}

output "ec2_public_ip" {
  value = module.webserver_creation.webserver.public_ip
}