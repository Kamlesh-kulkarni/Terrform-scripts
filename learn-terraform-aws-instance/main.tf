# Create EC2 instance

resource "aws_instance" "app_server" {
  ami           = var.os
  instance_type = var.instance_size
  security_groups = [aws_security_group.sg-app_server.name]
  
  # Keypair -
  key_name = "Terraform_demo"

  tags = {
    Name = var.instance_name
  }
}


# Security group using terraform 

resource "aws_security_group" "sg-app_server" {
  name        = "Security Group using terraform"
  description = "Security Group using terraform"
  vpc_id      = "vpc-0f5db5cf115c26015"    # default vpc id from aws console  

# inbound traffic
    ingress {
    description      = "HTTPS"
    from_port        = 22
    to_port          = 22
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  ingress {
    description      = "HTTP"
    from_port        = 80
    to_port          = 80
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }


# outbound traffic
  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  tags = {
    Name = "sg-app_server"
  }
}