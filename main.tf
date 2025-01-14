#configure AWS Provider
provider "aws" {
  region = "us-east-1"
}

#create a new security group

resource "aws_security_group" "example_sg" {
  name = "example-sg"
  description = "allow all HTTP and SSH traffic"

ingress {
  from_port = 22
  to_port =22
  protocol = "tcp"
  cidr_blocks = ["0.0.0.0/0"]
}

ingress {
  from_port = 80
  to_port = 80
  protocol = "tcp"
  cidr_blocks = ["0.0.0.0/0"]
}

egress {
  from_port = 0
  to_port = 0
  protocol = "-1"
  cidr_blocks = ["0.0.0.0/0"]
}
}

#creating aws key pair
resource "aws_key_pair" "example_key" {
  key_name = "my-key"
  public_key = file("C:/Users/sravs/OneDrive/.ssh/my_new_key.pub")
  
}
resource "aws_instance" "example" {
  ami           = "ami-0e86e20dae9224db8"
  instance_type = "t2.micro" 

  # Attach the security group and key pair
  security_groups = [aws_security_group.example_sg.name]
  key_name        = aws_key_pair.example_key.key_name

  tags = {
    Name = "ExampleInstance"
  }
  associate_public_ip_address = true
}
# Create an Internet Gateway for public access
resource "aws_internet_gateway" "example_igw" {
  vpc_id = aws_vpc.example_vpc.id
}

# Create a VPC
resource "aws_vpc" "example_vpc"{
  cidr_block = "10.0.0.0/16"
}
# Create a subnet
resource "aws_subnet" "example_subnet" {
  vpc_id                  = aws_vpc.example_vpc.id
  cidr_block              = "10.0.1.0/24"  # Subnet CIDR block
  availability_zone       = "us-east-1a"
  map_public_ip_on_launch = true
}
