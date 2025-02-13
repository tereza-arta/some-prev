#Vpc
variable "vpc_cidr" {
  default     = "10.0.0.0/16"
  description = "Cidr_block value of Vpc"
}

variable "tenancy" {
  default = "default"
  description = "Specify tenancy type"
}

variable "dns_support" {
  type = bool
  default = true
  description = "Enable dns support or not"
}

variable "dns_hostname" {
  type = bool
  default = false
  description = "Enable dns hostname or not"
}

variable "addr_usage_metrics" {
  type = bool
  default = false
  description = "Enable net-addr usage metrics or not"
}

variable "vpc_tag" {
  default = "Custom VPC"
}

variable "vpc_additional_tag" {
  default = "VPC from tf"
}

#Internet Gateway
variable "igw_tag" {
  default = "Custom Internet Gateway"
}

#Subnet
variable "az_cnt" {
  type = number
  default = 2
  description = "The number of taken AZ"
}

variable "map_public_ip" {
  type = bool
  default = true
  description = "Map pub-ip for public subnet"
}

variable "pub_sub_tag" {
  default = "Custom Public Subnet"
}

variable "priv_sub_tag" {
  default = "Custom Private Subnet"
}

variable "only_ipv6" {
  type = bool
  default = false
  description = "Create ipv6-only subnet or not"
}

variable "default_gateway" {
  default = "0.0.0.0/0"
}

variable "rt_tag" {
  default = "Nondefault Route Table"
  description = "Tag for second RT"
}

variable "eip_tag" {
  default = "Elastic IP"
}

variable "nat_tag" {
  default = "NAT Gateway"
}

#Security Group
variable "fnt_port" {
  type = number
  default = 3000
}

variable "lb_ing_proto" {
  type = list(string)
  default = ["tcp", "udp"]
}

variable "proto_ind" {
  type = number
  default = 0
  description = "Index of lb "
}

variable "sg_cnt" {
  type = number
  default = 3
  description = "Count of SG for ECS components"
}

variable "sg_ingress" {
    type = list(object({
      from   = number
      to    = number
      proto    = string
      cidr  = string
      desc = string
    }))
    default     = [
#        {
#          from   = 80
#          to     = 80
#          proto    = "tcp"
#          cidr  = "0.0.0.0/0"
#          desc = "Allow incoming http traffic"
        },
        {
          from   = 5432
          to     = 5432
          proto    = "tcp"
          cidr  = "0.0.0.0/0"
          desc = "Allow incoming postgress connection"
        },
        {
          from   = 5000
          to     = 5000
          proto    = "tcp"
          cidr  = "0.0.0.0/0"
          desc = "Allow incoming backend connection"
        },
        {
          from   = 3000
          to     = 3000
          proto    = "tcp"
          cidr  = "0.0.0.0/0"
          desc = "Allow incoming frontend connection"
        },
    ]
}

variable "sg_egress" {
    type = list(object({
      from   = number
      to    = number
      proto    = string
      cidr  = string
      desc = string
    }))
    default     = [
        {
          from   = 0
          to     = 0
          proto    = "-1"
          cidr  = "0.0.0.0/0"
          desc = "Allow all outgoing traffic"
        },
    ]
}


#variable "sg_ingress" {
#    type        = map(map(any))
#    default     = {
#        rule_1 = {from=80, to=80, proto="tcp", cidr="0.0.0.0/0", desc="test"}
#        rule_2 = {from=5432, to=5432, proto="tcp", cidr="0.0.0.0/0", desc="test"}
#        rule_2 = {from=5000, to=5000, proto="tcp", cidr="0.0.0.0/0", desc="test"}
#        rule_2 = {from=3000, to=3000, proto="tcp", cidr="0.0.0.0/0", desc="test"}
#    }
#}

variable "egress_proto" {
  default = "-1"
  description = "Specify SG egress protocol"
}

variable "egress_port" {
  type = number
  default = 0
}
