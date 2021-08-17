resource "tls_private_key" "pri" {
  algorithm = "RSA"
  rsa_bits  = 4096
}
resource "aws_key_pair" "kpa" {
  //Create a "myKey" to AWS!!
  key_name   = var.keypair_name[2]      
  public_key = tls_private_key.pri.public_key_openssh

  provisioner "local-exec" { 
  // Create a "Key.pem" to your computer!!
    command = "echo '${tls_private_key.pri.private_key_pem}' > ./${aws_key_pair.kpa.key_name}.pem"
  }
}

resource "aws_security_group" "clustersec" {
  name        = var.secgrp_name[2]
  description = "Allow TLS inbound traffic"
  vpc_id      = aws_vpc.tf_vpc.id

dynamic "ingress" {
    iterator = port
    for_each = var.ingressrules3
    content {
      from_port   = port.value
      to_port     = port.value
      protocol    = "TCP"
      cidr_blocks = ["0.0.0.0/0"]
    }
  }
  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  tags = {
    Name = "clustersec"
  }
}
resource "aws_ecs_cluster" "ecscluster" {
  name = var.cluster_name[0]

  setting {
    name  = "containerInsights"
    value = "enabled"
  }
}