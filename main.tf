terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 6.0"
    }
  }

  backend "s3" {
    bucket       = "terraform-state-azhar-2026"
    key          = "AWS-Infrastructure/terraform.tfstate"
    region       = "ap-south-1"
    use_lockfile = true

  }
}

provider "aws" {
  region = "ap-south-1"

}


module "network" {
  source = "./modules/network"

  aws_region            = var.aws_region
  vpc_cidr              = var.vpc_cidr
  public_subnet_a_cidr  = var.public_subnet_a_cidr
  private_subnet_a_cidr = var.private_subnet_a_cidr
  public_subnet_b_cidr  = var.public_subnet_b_cidr
  private_subnet_b_cidr = var.private_subnet_b_cidr

}

module "compute" {
  source = "./modules/compute"

  ami_id            = var.ami_id
  instance_type     = var.instance_type
  private_subnet_id = module.network.private_subnet_id
  key_name          = var.key_name

  security_group_id = aws_security_group.app.id

}


module "alb" {
  source = "./modules/alb"

  vpc_id = module.network.vpc_id

  public_subnet_a_id = module.network.public_subnet_id
  public_subnet_b_id = module.network.public_subnet_b_id

  traget_instance_id = module.compute.instance_id
  security_group_id  = aws_security_group.alb.id

}


resource "aws_security_group" "app" {
  name        = "lab15-app-sg"
  description = "security group for lab 15 application"
  vpc_id      = module.network.vpc_id


  ingress {
    description     = "Allow HTTP from ALB"
    from_port       = 80
    to_port         = 80
    protocol        = "tcp"
    security_groups = [module.alb.alb_security_group_id]
  }

  egress {
    description = "allow outbound rules"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "lab15-app-sg"
  }


}

resource "aws_security_group" "alb" {
  name        = "lab15-alb-sg"
  description = "security group for lab 15 ALB"
  vpc_id      = module.network.vpc_id

  ingress {
    description = "Allow HTTP from Internet"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    description = "Allow outbound traffic"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "lab15-alb-sg"
  }

}