variable "region" {
    type = string
    default = "us-east-1"
}
variable "aws_profile" {
    type    = string
    default = "ayush"
}

//vpc varibales

variable "vpc_nam" {
    type = string
    default = "myvpc"
}

variable "vpc_cidr" {
    type = string
    default = "10.1.0.0/16"
}

variable "vpc_dns_hostname" {
    type = bool
    default = true
}


variable "subnet_cidr" {
    default = [ "10.1.0.0/24" , "10.1.1.0/24" ]
}

variable "availability_zone" {
    default = [ "us-east-1a" , "us-east-1b" ]
}

variable "subnet_name" {
    default = [ "subnet-1" , "subnet-2" ]
}

variable "ig_name" {
    type    = string
    default = "my-ig"
}

variable "allowall" {
    type    = string
    default = "0.0.0.0/0"
}

variable "vpc_route_table_name" {
    type    = string
    default = "my_rt2"
}

//EC2 variables

variable "ec2_name" {
    type    = string
    default = "test"
}

variable "ami_id" {
    type    = string
    default = "ami-0747bdcabd34c712a"
}

variable "instance_type" {
    type    = string
    default = "t2.micro"
}

variable "keypair_name" {
    type    = string
    default = "automation_server_key"
}

variable "secgrp_name" {
    type    = string
    default = "testgrp"
}

variable "ingressrules" {
  type    = list(number)
  default = [80, 443, 22, 9586]
}

variable "ebs_size" {
    type    = number
    default = 10
}

variable "instance_az" {
    type    = string
    default = "us-east-1a"
}

variable "source_path" {
    type    = string
    default = "/home/ayush/Desktop/terraform/ECSdeploy/new/jenkins"
}

variable "destination_path" {
    type    = string
    default   = "/opt/docker"
}

variable "user_name" {
    type    = string
    default   = "ubuntu"
}