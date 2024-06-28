variable "region" {
  description = "The AWS region to create resources in"
  type        = string
  default     = "ap-south-1"
}

variable "vpc_cidr" {
  description = "The CIDR block for the VPC"
  type        = string
  default     = "10.0.0.0/16"
}

variable "subnet_cidr" {
  description = "The CIDR block for the subnet"
  type        = string
  default     = "10.0.2.0/24"
}

variable "availability_zone" {
  description = "The availability zone for the subnet"
  type        = string
  default     = "ap-south-1a"
}

variable "ami_id" {
  description = "The AMI ID to use for the instance"
  type        = string
  default     = "ami-0f58b397bc5c1f2e8" # Replace with your desired AMI ID
}

variable "instance_type" {
  description = "The instance type to use for the EC2 instance"
  type        = string
  default     = "t2.micro"
}
