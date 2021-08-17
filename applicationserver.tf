resource "tls_private_key" "prk" {
  algorithm = "RSA"
  rsa_bits  = 4096
}
resource "aws_key_pair" "krp" {
  //Create a "myKey" to AWS!!
  key_name   = var.keypair_name[1]      
  public_key = tls_private_key.prk.public_key_openssh

  provisioner "local-exec" { 
  // Create a "Key.pem" to your computer!!
    command = "echo '${tls_private_key.prk.private_key_pem}' > ./${aws_key_pair.krp.key_name}.pem"
  }
}

resource "aws_security_group" "allow" {
  name        = var.secgrp_name[1]
  description = "Allow TLS inbound traffic"
  vpc_id      = aws_vpc.tf_vpc.id

dynamic "ingress" {
    iterator = port
    for_each = var.ingressrules2
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
    Name = "allow"
  }
}
resource "aws_ebs_volume" "app_vol" {
  availability_zone = var.instance_az
  size              = var.ebs_size
  tags = {
    Name = "application_ebs"
  }
}

resource "aws_volume_attachment" "ebs_attach" {
  device_name = "/dev/sdh"
  volume_id   = aws_ebs_volume.app_vol.id
  instance_id = aws_instance.application.id
}

resource "aws_instance" "application" {
  ami           = var.ami_id[0]
  instance_type = var.instance_type
  //vpc_id = aws_vpc.tf_vpc.id
  subnet_id = aws_subnet.tf_subnet.id
  availability_zone = var.instance_az
  associate_public_ip_address = true
  vpc_security_group_ids = [aws_security_group.allow.id]
  key_name = aws_key_pair.krp.key_name


  provisioner "remote-exec" {
        connection {
          # The default username for our AMI
          user = var.user_name[0]
          host = "${self.public_ip}"
          type     = "ssh"
          private_key = tls_private_key.prk.private_key_pem
          //private_key = "${file("/home/ayush/Desktop/terraform/ECSdeploy/new/key.pem")}"
        }

        inline = [
          "sudo apt-get -y update",
          "sudo apt-get -y install docker.io",
          "sudo curl -L https://github.com/docker/compose/releases/download/1.21.2/docker-compose-`uname -s`-`uname -m` -o /usr/local/bin/docker-compose",
          "sudo chmod +x /usr/local/bin/docker-compose",
          "docker-compose --version",
          "sudo chmod 666 /var/run/docker.sock",
          "sudo mkdir -p /opt/docker",
          "sudo chown -R ubuntu:ubuntu /opt/docker",
          "cd /opt/docker && ls -lah"

        ]
      }
  
  tags = {
    Name = var.ec2_name[1]
  }
}

output "app_instance_ip" {
  description = "The public ip for ssh access"
  value       = aws_instance.application.public_ip
}
