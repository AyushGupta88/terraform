provider "aws" {
    //project = "ECS Deploy"
    region = var.region
    profile = var.aws_profile
}

resource "tls_private_key" "pk" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

resource "aws_key_pair" "kp" {
  //Create a "myKey" to AWS!!
  key_name   = var.key_name       
  public_key = tls_private_key.pk.public_key_openssh

  provisioner "local-exec" { 
  // Create a "myKey.pem" to your computer!!
    command = "echo '${tls_private_key.pk.private_key_pem}' > ./key.pem"
  }
}
resource "aws_security_group" "allow_tls" {
  name        = var.testgrp
  description = "Allow TLS inbound traffic"
  vpc_id      = aws_vpc.tf_vpc.id

  ingress {
    description      = "TLS from anywhere"
    from_port        = 443
    to_port          = 443
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }
  ingress {
    description      = "ssh from anywhere"
    from_port        = 22
    to_port          = 22
    protocol         = "ssh"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }
  ingress {
    description      = "Http from anywhere"
    from_port        = 80
    to_port          = 80
    protocol         = "http"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }
  ingress {
    description      = "Http from anywhere"
    from_port        = 9532
    to_port          = 9532
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }
  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  tags = {
    Name = "allow_tls"
  }
}

resource "aws_ebs_volume" "test" {
  availability_zone = var.instance_az
  size              = var.ebs_size
  tags = {
    Name = "testebs
  }
}

resource "aws_volume_attachment" "ebs_att" {
  device_name = "/dev/sdh"
  volume_id   = aws_ebs_volume.test.id
  instance_id = aws_instance.test.id
}

resource "aws_instance" "test" {
  ami           = var.ami_id
  instance_type = var.instance_type
  vpc_id = aws_vpc.tf_vpc.id
  subnet_id = aws_subnet.tf_subnet.id
  availability_zone = var.instance_az
  associate_public_ip_address = "true"
  key_name = aws_key_pair.kp.key_name
  vpc_security_group_ids = aws_security_group.allow_tls.id
  
  tags = {
    Name = "Testinstance"
  }
}