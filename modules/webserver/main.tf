resource "aws_security_group" "myapp_sg" {
  name        = "myapp_sg"
  description = "Allow SSH & HTTP traffic"
  vpc_id      = var.vpc_id

  ingress {
    description = "Allow SSH"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = [var.my_ip]
  }

  ingress {
    description = "Allow HTTP"
    from_port   = 8080
    to_port     = 8080
    protocol    = "tcp"
    cidr_blocks = [var.internet_cidr_block]
  }

  egress {
    from_port       = 0
    to_port         = 0
    protocol        = "-1"
    cidr_blocks     = [var.internet_cidr_block]
    prefix_list_ids = []
  }

  tags = {
    Name = "${var.env_prefix}-${var.region}-myapp_SG"
  }
}

resource "aws_key_pair" "myapp_ssh-key" {
  key_name   = "myapp_server-key"
  public_key = file(var.public_key_path)
}

resource "aws_instance" "myapp_webserver" {
  ami           = data.aws_ami.latest-amazon-linux-image.id
  instance_type = "t2.micro"

  subnet_id         = var.subnet_id
  availability_zone = var.availability_zone

  associate_public_ip_address = true
  key_name = aws_key_pair.myapp_ssh-key.key_name

  vpc_security_group_ids = [aws_security_group.myapp_sg.id]

  user_data = file(var.entry_script)

  tags = {
    Name = "${var.env_prefix}-${var.region}-myapp_webserver"
  }
}