resource "aws_security_group" "allow_tls_db" {
  name        = var.secgrp_name[3]
  description = "Allow database TLS inbound traffic"
  vpc_id      = aws_vpc.tf_vpc.id

dynamic "ingress" {
    iterator = port
    for_each = var.ingressdb
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
    Name = "allow_tls_db"
  }
}

resource "aws_db_instance" "postgresdb" {
  
  identifier = var.identifier 
  allocated_storage    = 10
  engine               = var.engine
  engine_version       = var.engine_version
  instance_class       = var.instance_class
  name                 = var.initial_db_name
  username             = var.master_username
  password             = var.master_pass
  parameter_group_name = var.parameter_group_name
  skip_final_snapshot  = true
  maintenance_window = "Mon:00:00-Mon:03:00"
  backup_window      = "03:00-06:00"
  publicly_accessible = false
  storage_encrypted   = false
  vpc_security_group_ids = [aws_security_group.allow_tls_db.id]
  deletion_protection  = false
  multi_az = false
  performance_insights_enabled = false
  
  tags = {
    name = "mytestdb"
  }
}

output "db_instance_endpoint" {
  description = "The connection endpoint"
  value       = aws_db_instance.postgresdb.endpoint
}

output "db_instance_status" {
  description = "The RDS instance status"
  value       = aws_db_instance.postgresdb.status
}


