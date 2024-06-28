provider "aws" {
  region = var.region
}

# Create a VPC
resource "aws_vpc" "webserver" {
  cidr_block = var.vpc_cidr

  tags = {
    Name = "web-server-vpc"
  }
}

# Create a subnet
resource "aws_subnet" "webserver_subnet" {
  vpc_id            = aws_vpc.webserver.id
  cidr_block        = var.subnet_cidr
  availability_zone = var.availability_zone

  tags = {
    Name = "webserver-subnet"
  }
}

# Create an internet gateway
resource "aws_internet_gateway" "webserver" {
  vpc_id = aws_vpc.webserver.id

  tags = {
    Name = "webserver-igw"
  }
}

# Create a route table
resource "aws_route_table" "webserver" {
  vpc_id = aws_vpc.webserver.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.webserver.id
  }

  tags = {
    Name = "webserver-route-table"
  }
}

# Associate the route table with the subnet
resource "aws_route_table_association" "webserver" {
  subnet_id      = aws_subnet.webserver_subnet.id
  route_table_id = aws_route_table.webserver.id
}

# Create a security group
resource "aws_security_group" "webserver" {
  vpc_id = aws_vpc.webserver.id

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "webserver-security-group"
  }
}

# Create an IAM role for SSM
resource "aws_iam_role" "ec2_role" {
  name = "ec2_role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "ec2.amazonaws.com"
        }
      }
    ]
  })

  tags = {
    Name = "ec2-role"
  }
}

# Attach the AmazonSSMManagedInstanceCore policy to the role
resource "aws_iam_role_policy_attachment" "ec2_ssm_policy_attachment" {
  role       = aws_iam_role.ec2_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
}

# Create an IAM instance profile
resource "aws_iam_instance_profile" "ec2_ssm_instance_profile" {
  name = "ec2_ssm_instance_profile"
  role = aws_iam_role.ec2_role.name

  tags = {
    Name = "ec2-ssm-instance-profile"
  }
}

# Create an EC2 instance
resource "aws_instance" "webserver" {
  ami                  = var.ami_id
  instance_type        = var.instance_type
  subnet_id            = aws_subnet.webserver_subnet.id
  vpc_security_group_ids = [aws_security_group.webserver.id]
  iam_instance_profile = aws_iam_instance_profile.ec2_ssm_instance_profile.name
  associate_public_ip_address = true 
  
  tags = {
    Name = "web-server"
  }
}
