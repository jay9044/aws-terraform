resource "aws_vpc" "myapp_vpc" {
  cidr_block = var.vpc_cidr_block

  enable_dns_hostnames = true
  tags = {
    Name = "${var.env_prefix}-${var.region}-vpc"
  }
}

module "subnet_creation" {
  source              = "./modules/subnet"
  vpc_id              = aws_vpc.myapp_vpc.id
  subnet_cidr_block   = var.subnet_cidr_block
  internet_cidr_block = var.internet_cidr_block
  availability_zone   = var.availability_zone
  env_prefix          = var.env_prefix
  region              = var.region

}

module "webserver_creation" {
  source              = "./modules/webserver"
  vpc_id              = aws_vpc.myapp_vpc.id
  subnet_id           = module.subnet_creation.subnet.id
  my_ip               = var.my_ip
  public_key_path     = var.public_key_path
  internet_cidr_block = var.internet_cidr_block
  availability_zone   = var.availability_zone
  env_prefix          = var.env_prefix
  region              = var.region
  entry_script        = var.entry_script
}