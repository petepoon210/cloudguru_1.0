variable "vpc_id" {
}

variable "subnet_id" {
}

variable "vpc_endpoints" {
  description = "Map of VPC endpoint configurations, including VPC details, region, and endpoints"
  type = map(object({    
    region         = string
    rdp_access_id  = string
    http_access_id = string
    endpoints      = map(object({
      service_name_suffix = string
      vpc_endpoint_type   = string
      private_dns_enabled = bool
      ip_address_type     = string
    }))
  }))
}