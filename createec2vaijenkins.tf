terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.0"
    }
  }
}
provider "aws" {
  region     = "us-west-2"
   access_key = "AKIAVRUVP4MMVW22P5NL"
  secret_key = "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"
}



#Create EC2 Instance
resource "aws_instance" "EC2-via-jenkins" {
  ami                    = "ami-0395649fbe870727e"
  instance_type          = "t2.micro"
  private_key = "/home/jenkins/slave/workspace/demo-create-infra-via-terraform/kulture.ppk"
  vpc_security_group_ids = [aws_security_group.jenkins_sg27.id]
  tags = {
    Name = "EC2-via-jenkins"
  }

  #Bootstrap Jenkins installation and start  
  user_data = <<-EOF
  #!/bin/bash
 sudo yum update
 amazon-linux-extras install epel -y
 amazon-linux-extras install ansible2 -y
  EOF 
  user_data_replace_on_change = true
}


resource "aws_security_group" "jenkins_sg27" {
  name        = "jenkins_sg27"
  description = "Open ports 22, 8080, and 443"

  #Allow incoming TCP requests on port 22 from any IP
  ingress {
    description = "Incoming SSH"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  #Allow incoming TCP requests on port 8080 from any IP
  ingress {
    description = "Incoming 8080"
    from_port   = 8080
    to_port     = 8080
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  #Allow incoming TCP requests on port 443 from any IP
  ingress {
    description = "Incoming 443"
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  #Allow all outbound requests
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "jenkins_sg27"
  }
}
