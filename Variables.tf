variable "region" {
    type = string
    default = "us-east-1"
}
variable "aws_profile" {
    type    = string
    default = "ayush"
}
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