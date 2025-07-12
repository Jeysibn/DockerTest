provider "aws" {
  region = var.aws_region
}

resource "aws_vpc" "main" {
  cidr_block = var.vpc_cidr

  tags = {
    Name        = "${var.project_name}-vpc"
    Environment = var.environment
  }
}

resource "aws_subnet" "public" {
  vpc_id                  = aws_vpc.main.id
  cidr_block              = var.public_subnet_cidr
  map_public_ip_on_launch = true
  availability_zone       = "${var.aws_region}a"

  tags = {
    Name        = "${var.project_name}-public-subnet"
    Environment = var.environment
  }
}

resource "aws_instance" "web" {
  ami           = "ami-0f09f9be05d8af1cd" # Amazon Linux 2023
  instance_type = "t2.micro"
  subnet_id     = aws_subnet.public.id

  tags = {
    Name        = "${var.project_name}-web-server"
    Environment = var.environment
  }
}
