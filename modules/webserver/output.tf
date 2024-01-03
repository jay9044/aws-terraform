output "webserver" {
  value = aws_instance.myapp_webserver
}

output "ami" {
  value = data.aws_ami.latest-amazon-linux-image
}