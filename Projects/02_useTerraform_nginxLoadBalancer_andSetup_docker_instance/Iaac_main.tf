provider "aws" {
  region     = var.AWS_Region
  access_key = var.AWS_Access_Key
  secret_key = var.AWS_Private_Key
}


// Create Security Group for Jenkins Server
resource "aws_security_group" "jenkinServer_SG" {
  name = "jenkinServer_SG2"
  ingress {
    description = "SSH on the machine from my IP"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["115.42.78.170/32"]
  }
  ingress {
    description = "Access Jenkins Dashboard from web"
    from_port   = 8080
    to_port     = 8080
    protocol    = "tcp"
    cidr_blocks = ["115.42.78.170/32"]
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  tags = {
    Name = "jenkinServer_SG"
  }
}

// Create Security Group for Ansible Control Panel
resource "aws_security_group" "Ansible_ControlPanel_SG" {
  name = "Ansible_ControlPanel_SG2"

  ingress {
    description = "SSH on the machine from my IP"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["115.42.78.170/32"]
  }
  ingress {
    description     = "Access Ansible CP by Jenkins Server"
    from_port       = 22
    to_port         = 22
    protocol        = "tcp"
    security_groups = [aws_security_group.jenkinServer_SG.id]
  }
  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  tags = {
    Name = "Ansible_ControlPanel_SG"
  }
}

// Create Security Group for Ansible WorkerNodes
resource "aws_security_group" "Ansible_WorkerNodes_SG" {
  name = "Ansible_WorkerNodes_SG2"

  ingress {
    description = "SSH on the machine from my IP"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["115.42.78.170/32"]
  }
  ingress {
    description     = "Access Ansible CP by Jenkins Server"
    from_port       = 22
    to_port         = 22
    protocol        = "tcp"
    security_groups = [aws_security_group.Ansible_ControlPanel_SG.id]
  }
  ingress {
    description      = "Access WorkerNodes on Web"
    from_port        = 80
    to_port          = 80
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }
  ingress {
    description      = "Access WorkerNodes on Web"
    from_port        = 443
    to_port          = 443
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
    Name = "Ansible_WorkerNodes_SG"
  }
}

// Setup Jenkins Server with t2.micro
resource "aws_instance" "JenkinServer_RS" {
  ami             = "ami-006d3995d3a6b963b"
  instance_type   = "t2.micro"
  key_name        = "devopsProj"
  security_groups = [aws_security_group.jenkinServer_SG.name]
  tags = {
    Name = "Jenkin Server"
  }

  user_data = <<-EOL
    #!/bin/bash -xe

    apt update
    apt install openjdk-11-jdk --yes
    wget -q -O - https://pkg.jenkins.io/debian-stable/jenkins.io.key | sudo apt-key add -
    sudo sh -c 'echo deb http://pkg.jenkins.io/debian-stable binary/ > /etc/apt/sources.list.d/jenkins.list'
    apt update
    apt install -y jenkins
    systemctl start jenkins
    systemctl status jenkins
    mkdir /homebaba
    EOL
}

// Setup Ansible Controler System
resource "aws_instance" "Ansible_Control_Panel_RS" {
  ami             = "ami-006d3995d3a6b963b"
  instance_type   = "t2.micro"
  key_name        = "devopsProj"
  security_groups = [aws_security_group.Ansible_ControlPanel_SG.name]

  tags = {
    Name = "Ansible Control Panel"
  }

  user_data = <<-EOL
    #!/bin/bash -xe

    apt update
    apt install ansible -y
    apt install git -y
    cd /home/ubuntu/
    git clone https://github.com/aslambaba/devops
    EOL   
}

// Setup Ansible WorkerNodes_#1
resource "aws_instance" "Ansible_WorkerNode_1" {
  ami             = "ami-006d3995d3a6b963b"
  instance_type   = "t2.micro"
  key_name        = "devopsProj"
  security_groups = [aws_security_group.Ansible_WorkerNodes_SG.name]
  tags = {
    Name = "#1_AnsibleWorkerNode_Nginx"
  }

  user_data = <<-EOL
    #!/bin/bash -xe

    apt update
    apt install nginx
    systemctl start nginx
    EOL   
}

// Setup Ansible WorkerNodes_#2
resource "aws_instance" "Ansible_WorkerNode_2" {
  ami             = "ami-006d3995d3a6b963b"
  instance_type   = "t2.micro"
  key_name        = "devopsProj"
  security_groups = [aws_security_group.Ansible_WorkerNodes_SG.name]
  tags = {
    Name = "#2_AnsibleWorkerNode_Nginx"
  }

  user_data = <<-EOL
    #!/bin/bash -xe

    apt update
    apt install nginx
    systemctl start nginx
    EOL   
}

// Setup Ansible WorkerNodes_#3
resource "aws_instance" "Ansible_WorkerNode_3" {
  ami             = "ami-006d3995d3a6b963b"
  instance_type   = "t2.micro"
  key_name        = "devopsProj"
  security_groups = [aws_security_group.Ansible_WorkerNodes_SG.name]
  tags = {
    Name = "#3_AnsibleWorkerNode_Docker"
  }

  user_data = <<-EOL
    #!/bin/bash -xe

    apt update 
    apt-get remove docker docker-engine docker.io containerd runc -y
    apt-get install \
    ca-certificates \
    curl \
    gnupg \
    lsb-release -y
    mkdir -p /etc/apt/keyrings
    curl -fsSL https://download.docker.com/linux/debian/gpg | sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg
    echo \
    "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/debian \
    $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
    apt-get update -y
    apt-get install docker-ce docker-ce-cli containerd.io docker-compose-plugin -y
    EOL   
}

// Setup Ansible WorkerNodes_#2 for Nginx Loadbalancer
resource "aws_instance" "Nginx_LoadBalancer" {
  ami             = "ami-006d3995d3a6b963b"
  instance_type   = "t2.micro"
  key_name        = "devopsProj"
  security_groups = [aws_security_group.Ansible_WorkerNodes_SG.name]
  tags = {
    Name = "Nginx_LoadBalancer"
  }
  user_data = <<-EOL
    #!/bin/bash -xe

    apt update
    apt install nginx -y
    systemctl start nginx
    EOL   
}
