# VPC Module
variable "vpc" {
    type=map(object({
        name                    = string
        vpc_cidr                = string
        vpc_tags                = map(string)
        private_cidrs           = list(string)
        private_routes          = list(string)
        map_public_ip_on_launch = bool
        igw                     = bool
    }))
    default = {
      "vpc1" = {
          name = "vpc1"
          vpc_cidr = "10.214.68.0/22"
          vpc_tags = {
            Name = "vpc1-logging"          
          }
          private_cidrs =  ["10.214.68.0/24", "10.214.69.0/24"]
          private_routes = ["10.0.0.0/8", "172.21.0.0/16", "192.168.123.0/24"]
          map_public_ip_on_launch = true  
          igw = true       
      },
      "vpc2" = {
          name = "vpc2"
          vpc_cidr = "10.214.80.0/22"
          vpc_tags = {
            Name = "vpc2-data"          
          }
          private_cidrs =  ["10.214.82.0/24", "10.214.83.0/24"]
          private_routes = ["10.0.0.0/8", "172.21.0.0/16", "192.168.123.0/24"]
          map_public_ip_on_launch = true   
          igw = true      
      }
    }
}


# KEY Module
variable "linux_public_key" {
  default = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQCk0bk4DHuFnnoMpH95OamZJC2g4MIVfQCBP6s4wk56nIhsXXS+bQ7avGh4Rns9C4LLSRqJ63hd3bHSH+7ko7azum+rxRt3OczswXVEJqupNt2o8FJBznmQ7wB8yxWoNeT6pqCTpXIoCJOGxkfgCKZAHtbSBebcXpJ/ESqdUALS0Y/Oz2Y1cwK74U/pPoGEAkfumyBHH87VtKHQCrhMCc/2GdDDdQlrshuU/J0deQpm/tqE7uZLMRT/7G04v4nwIQuc5P76/jfoJSs4irM5baRkGoxafPFB5kd8+eoknRFArpl4yVInF+2/mA1TkEKC2Xg8bnI0Z3TlpsQ8P5HopSllOfYzn0TxVfh/R0swiMetqBOXipqickfkANBjGAlf63uoMN8Rrfryf8FybVOBmGN1Ww3hSRn4QgnhTwk+cww+sU8FF0vjTcKuyjsTAEIlNSxMMxHYMTo/UrAxg9jfTSwjBPWd1Xjhp56H7LM4p/66oZqVcvLwuM4UdR3DcWUULmk= aws_terraform_ssh_key"
}

variable "windows_public_key" {
  default = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQDKHPOjuTFVqZzQaaGNPYHnb9n306XPWfMaM8WqpuI0jIBKbXDB7Vy2z6S7kOhl9Yklq54p9LfZngWOyOEbQo/eCsBH9Ed68Iu8q/+wKoHrfc7G8UZNSNd4XX71krAHQcEfMuR+jUIDmR4ZR17nv2f3+D5ehfUg3fSZFtSdLbJZUSTGjiL/hJ4mCIsxwPi50JdBm68b5pWiUG7MB5NjYtfm6NUpURYmLgFdhRNKU9ER5LSBL3+prR5QHxBvB4bomCfCJ3O0pnvdUoSKj7ppuOIbOrWN7QF9VcB5UPo38+ksoaUCwq+uUyt3aGXJgaW0aNr2ZlrdOuTsPZG+LqwOZ2RjhGZOu8uALfHkWSxD+e10qNchIYCwb+K6OAmp1vuQ+I0GMOdsvHQgtzOtOETCVr4lSrpq/DK9BaSe7QXqY4CnK9Jm2Oos6pjl0J5vQTVPLjrHYhXt0ipz5MWN8OBnsjw0BZKWHcRS/IOedw7RHtbBqYs0HqbKJpwDtvtrPcu5VSM= ktsang@ubunut01"
}

# EC2 Module
# data "aws_ami" "ubuntu" {
#   most_recent = true

#   filter {
#     name   = "name"
#     values = ["ubuntu/images/hvm-ssd/ubuntu-bionic-18.04-amd64-server-*"]
#   }

#   filter {
#     name   = "virtualization-type"
#     values = ["hvm"]
#   }

#   owners = ["099720109477"] # Canonical
# }
data "aws_ami" "ubuntu" {
  most_recent = true

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-jammy-22.04-amd64-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  owners = ["amazon"] # Canonical
}

data "aws_ami" "amazon-linux-2" {
 most_recent = true


 filter {
   name   = "owner-alias"
   values = ["amazon"]
 }


 filter {
   name   = "name"
   values = ["amzn2-ami-hvm*"]
 }
}

data "aws_ami" "windows" {
  most_recent = true

  filter {
    name   = "name"
    values = ["Windows_Server-2022-English-Full-Base-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
  owners = ["801119661308"] # Canonical
}

variable "ec2_linux" {
    type=map(object({
        vpc                  = string
        subnet               = number        
        instance_type        = string
        private_ip           = string
        public_ip            = bool
        key_name             = string
    }))
    default = {
      "ec2_1" = {
          vpc             = "vpc1"
          subnet          = 0
          instance_type   = "t3.medium"
          private_ip      = "10.214.68.10"
          public_ip       = true
          key_name        = "linux-keypair"
      }
      "ec2_2" = {
          vpc             = "vpc1"
          subnet          = 1
          instance_type   = "t3.medium"
          private_ip      = "10.214.69.10"
          public_ip       = true
          key_name        = "linux-keypair"
      }
    }
}
 
# data "terraform_remote_state" "gitlab" {
#   backend = "http"
#   config = {
#     address = var.gitlab_remote_state_address
#     username = var.gitlab_username
#     password = var.gitlab_access_token
#   }
# }

variable "ec2_windows" {
    type=map(object({
        vpc                  = string
        subnet               = number        
        instance_type        = string
        private_ip           = string
        public_ip            = bool
        key_name             = string
    }))
    default = {
      "ec2_1" = {
          vpc             = "vpc2"
          subnet          = 0
          instance_type   = "t3.medium"
          private_ip      = "10.214.82.10"
          public_ip       = true
          key_name        = "windows-keypair"
      }
    }
}

# EKS
variable "eks_version" {
  type = string
  default = "1.27"
}

locals {
  cluster_name = "my-eks-cluster"
}

# MODULE

module "TGW" {
  source        = "./modules/transitgw"
}

module "VPC" {
  depends_on = [module.TGW]
  source        = "./modules/networking"
  for_each = var.vpc
  vpc_cidr                  = each.value.vpc_cidr
  vpc_tags                  = each.value.vpc_tags  
  private_cidrs             = each.value.private_cidrs
  private_routes            = each.value.private_routes
  map_public_ip_on_launch   = each.value.map_public_ip_on_launch
  igw                       = each.value.igw
  tgw_id                    = module.TGW.tgw_id
  tgw_rt_id                 = module.TGW.tgw_rt_id
}

module "KEY" {
  source        = "./modules/key"
  linux_public_key    = var.linux_public_key
  windows_public_key  = var.windows_public_key
}

module "http_access" {
  source = "./modules/security_group"  
  for_each = var.vpc
  vpc_id    = module.VPC[each.value.name].vpc_id

  security_group_config = {
    name        = "http_access"
    description = "Allow HTTP access"
    ingress = [
      {
        from_port   = 22
        to_port     = 22
        protocol    = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
      },
      {
        from_port   = 80
        to_port     = 80
        protocol    = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
      },
      {
        from_port   = 4001
        to_port     = 4001
        protocol    = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
      },
      {
        from_port   = 8
        to_port     = 0
        protocol    = "icmp"
        cidr_blocks = ["0.0.0.0/0"]
      },
      {
        from_port   = 443
        to_port     = 443
        protocol    = "tcp"
        cidr_blocks = ["10.214.0.0/16"]
      },
      {
        from_port   = 500
        to_port     = 500
        protocol    = "udp"
        cidr_blocks = ["172.21.86.196/32"]
      },
      {
        from_port   = 4500
        to_port     = 4500
        protocol    = "udp"
        cidr_blocks = ["172.21.86.196/32"]
      }
    ]
    egress = [
      {
        from_port   = 0
        to_port     = 0
        protocol    = "-1"
        cidr_blocks = ["0.0.0.0/0"]
      }
    ]
  }
}

module "rdp_access" {
  source = "./modules/security_group"  
  for_each = var.vpc
  vpc_id    = module.VPC[each.value.name].vpc_id

  security_group_config = {
    name        = "rdp_access"
    description = "Allow RDP access"
    ingress = [
      {
        from_port   = "3389"
        to_port     = "3389"
        protocol    = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
      },
      {
        from_port   = 80
        to_port     = 80
        protocol    = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
      },
      {
        from_port   = 4001
        to_port     = 4001
        protocol    = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
      },
      {
        from_port   = 8
        to_port     = 0
        protocol    = "icmp"
        cidr_blocks = ["0.0.0.0/0"]
      },
      {
        from_port   = 443
        to_port     = 443
        protocol    = "tcp"
        cidr_blocks = ["10.214.0.0/16"]
      },
      {
        from_port   = 500
        to_port     = 500
        protocol    = "udp"
        cidr_blocks = ["172.21.86.196/32"]
      },
      {
        from_port   = 4500
        to_port     = 4500
        protocol    = "udp"
        cidr_blocks = ["172.21.86.196/32"]
      }
    ]
    egress = [
      {
        from_port   = 0
        to_port     = 0
        protocol    = "-1"
        cidr_blocks = ["0.0.0.0/0"]
      }
    ]
  }
}

module "EC2_LINUX" {
  source        = "./modules/ec2_linux"
  for_each = var.ec2_linux
  ami                         = data.aws_ami.ubuntu.id
  instance_type               = each.value.instance_type
  subnet_id                   = module.VPC[each.value.vpc].subnet_ids[each.value.subnet] 
  vpc_security_group_ids      = [module.rdp_access[each.value.vpc].security_group_id, module.http_access[each.value.vpc].security_group_id]
  key_name                    = each.value.key_name
  private_ip                  = each.value.private_ip
  associate_public_ip_address = each.value.public_ip
  iam_instance_profile        = aws_iam_instance_profile.ssm_profile.name
}

resource "aws_subnet" "additional" { 
   vpc_id = module.VPC["vpc1"].vpc_id
   cidr_block = "10.214.70.0/24"
   availability_zone = "us-west-2a"
   tags = {
        Name = "private-1"
      }
   depends_on = [module.VPC]  
}

resource "aws_network_interface" "additional" {
  subnet_id = aws_subnet.additional.id
  private_ips = ["10.214.70.10"]
  security_groups = [module.http_access["vpc1"].security_group_id] 
  attachment {
    instance = module.EC2_LINUX["ec2_1"].aws_ec2_instance_id
    device_index = 1
  } 
  depends_on = [module.EC2_LINUX,
                aws_subnet.additional
  ]  
}


module "EC2_WINDOWS" {
  source        = "./modules/ec2_windows"
  for_each = var.ec2_windows
  ami                         = data.aws_ami.windows.id
  instance_type               = each.value.instance_type
  subnet_id                   = module.VPC[each.value.vpc].subnet_ids[each.value.subnet] 
  vpc_security_group_ids      = [module.rdp_access[each.value.vpc].security_group_id]
  key_name                    = each.value.key_name
  private_ip                  = each.value.private_ip
  associate_public_ip_address = each.value.public_ip
  iam_instance_profile        = aws_iam_instance_profile.ssm_profile.name
}

