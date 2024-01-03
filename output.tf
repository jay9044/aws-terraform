output "aws_ami" {
  value = data.aws_ami.latest-amazon-linux-image
}

output "ec2_public_dns" {
  value = aws_instance.myapp_webserver.public_dns
}

output "ec2_public_ip" {
  value = aws_instance.myapp_webserver.public_ip
}