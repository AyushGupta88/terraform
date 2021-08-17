variable "region" {
    type = string
    default = "us-east-1"
}
variable "aws_profile" {
    type    = string
    default = "ayush"
}

//vpc varibales

variable "vpc_name" {
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
    default = [ "10.1.0.0/24" , "10.1.1.0/24", "10.1.2.0/24" ]
}

variable "availability_zone" {
    default = [ "us-east-1a" , "us-east-1b" , "us-east-1c"]
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
    default = [ "automation" , "application" ]
}

variable "ami_id" {
    default = ["ami-0747bdcabd34c712a" , "ami-01453e60fc2aef316"]
}

variable "instance_type" {
    type    = string
    default = "t2.micro"
}

variable "keypair_name" {
    default = ["automation_server_key" , "application_server_key", "cluster_key"]
}

variable "secgrp_name" {
    default = ["automationsecgrp" , "applicationsecgrp" , "clustersecgrp", "dbsecgrp"]
}

variable "ingressrules" {
  type    = list(number)
  default = [80, 443, 22, 9586]
}

variable "ingressrules2" {
  type    = list(number)
  default = [22]
}
variable "ingressrules3" {
  type    = list(number)
  default = [80, 443, 22] 
}
variable "ingressdb" {
    type  = list(number)
    default = [5432,22]
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
    default   = ["ubuntu" , "any"]
}

variable "cluster_name" {
    default = ["test"]
}

//RDS Variables
variable "identifier" {
    type  = string
    default = "mytestdb"
}
variable "engine" {
    type  = string
    default = "PostgreSQL"
}
variable "allocated_storage" {
    type  = number
    default = 10
}
variable "engine_version" {
    type  = string
    default = "13.3-R1"
}
variable "instance_class" {
    type  = string
    default = "db.t3.micro"
}
variable "initial_db_name" {
    type = string
    default ="test"
}
variable "master_username" {
    type  = string
    default = "postgres"
}
variable "master_pass" {
    type  = string
    default = "affhghjahd"
}
variable "parameter_group_name" {
    type = string
    default = "default.postgres13"
}

variable "ecrnames" {
    type = list(string)
    default = ["frontend","backend"]
}