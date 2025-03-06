variable "vpc_cidr" {
    default = "10.10.0.0/16"
}

variable "vpc_tags" {
    default = {
        Name = "vpc1-dev"
    }
}

variable "private_cidrs" {
    default = ["10.10.1.0/24", "10.10.2.0/24"]
}

variable "map_public_ip_on_launch" {
    type = bool
}

variable "igw" {
    type = bool
}

variable "private_routes" {
    
}

variable "tgw_id" {
    
}

variable "tgw_rt_id" {
    
}