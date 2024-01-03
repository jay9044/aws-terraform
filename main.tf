resource "aws_vpc" "myapp_vpc" {
  cidr_block = var.vpc_cidr_block

  enable_dns_hostnames = true
  tags = {
    Name = "${var.env_prefix}-${var.region}-vpc"
  }
}

resource "aws_subnet" "myapp_subnet_1" {
  vpc_id            = aws_vpc.myapp_vpc.id
  cidr_block        = var.subnet_cidr_block
  availability_zone = var.availability_zone
  tags = {
    Name = "${var.env_prefix}-${var.region}-subnet"
  }
}

resource "aws_internet_gateway" "myapp_igw" {
  vpc_id = aws_vpc.myapp_vpc.id

  tags = {
    Name = "${var.env_prefix}-${var.region}-igw"
  }
}

resource "aws_route_table" "myapp_rtb" {
  vpc_id = aws_vpc.myapp_vpc.id

  route {
    cidr_block = var.internet_cidr_block
    gateway_id = aws_internet_gateway.myapp_igw.id
  }

  tags = {
    Name = "${var.env_prefix}-${var.region}-rtb"
  }
}

resource "aws_route_table_association" "myapp_rtb_association" {
  subnet_id      = aws_subnet.myapp_subnet_1.id
  route_table_id = aws_route_table.myapp_rtb.id
}

resource "aws_security_group" "myapp_sg" {
  name        = "myapp_sg"
  description = "Allow SSH & HTTP traffic"
  vpc_id      = aws_vpc.myapp_vpc.id

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

data "aws_ami" "latest-amazon-linux-image" {
  most_recent = true
  owners      = ["amazon"]

  filter {
    name   = "name"
    values = ["amzn2-ami-hvm-*-x86_64-gp2"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
}

resource "aws_key_pair" "myapp_ssh-key" {
  key_name   = "myapp_server-key"
  public_key = file(var.public_key_path)
}

resource "aws_instance" "myapp_webserver" {
  ami           = data.aws_ami.latest-amazon-linux-image.id
  instance_type = "t2.micro"

  subnet_id         = aws_subnet.myapp_subnet_1.id
  availability_zone = var.availability_zone

  associate_public_ip_address = true
  key_name                    = aws_key_pair.myapp_ssh-key.key_name

  vpc_security_group_ids = [aws_security_group.myapp_sg.id]

  //user data
  tags = {
    Name = "${var.env_prefix}-${var.region}-myapp_webserver"
  }
}