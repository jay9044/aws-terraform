resource "aws_subnet" "myapp_subnet_1" {
  vpc_id            = var.vpc_id
  cidr_block        = var.subnet_cidr_block
  availability_zone = var.availability_zone
  tags = {
    Name = "${var.env_prefix}-${var.region}-subnet"
  }
}

resource "aws_internet_gateway" "myapp_igw" {
  vpc_id = var.vpc_id

  tags = {
    Name = "${var.env_prefix}-${var.region}-igw"
  }
}

resource "aws_route_table" "myapp_rtb" {
  vpc_id = var.vpc_id

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