provider "aws" {
    //project = "ECS Deploy"
    region = var.region
    profile = var.aws_profile
}
//vpc 
resource "aws_vpc" "tf_vpc" {
  cidr_block       = var.vpc_cidr
  instance_tenancy = "default"
  enable_dns_hostnames = var.vpc_dns_hostname
  tags = {
    Name = var.vpc_nam
  }
}
resource "aws_subnet" "tf_subnet" {
  vpc_id     = aws_vpc.tf_vpc.id
  cidr_block = var.subnet_cidr[0]
  availability_zone = var.availability_zone[0]
  map_public_ip_on_launch = true

  tags = {
    Name = var.subnet_name[0]
  }
}
resource "aws_subnet" "tf_subnet2" {
  vpc_id     = aws_vpc.tf_vpc.id
  cidr_block = var.subnet_cidr[1]
  availability_zone = var.availability_zone[1]
  map_public_ip_on_launch = true

  tags = {
    Name = var.subnet_name[1]
  }
}
resource "aws_internet_gateway" "tf_gw" {
  vpc_id = aws_vpc.tf_vpc.id

  tags = {
    Name = var.ig_name
  }
}
resource "aws_route_table" "tf_rt" {
    vpc_id = aws_vpc.tf_vpc.id

    route {
        gateway_id = aws_internet_gateway.tf_gw.id
        cidr_block = var.allowall
    }

    tags = {
        Name = var.vpc_route_table_name
    }
}
resource "aws_route_table_association" "tf_sub_a" {
    subnet_id      = aws_subnet.tf_subnet.id
    route_table_id = aws_route_table.tf_rt.id
}

resource "aws_route_table_association" "tf_sub_b" {
    subnet_id      = aws_subnet.tf_subnet2.id
    route_table_id = aws_route_table.tf_rt.id
}