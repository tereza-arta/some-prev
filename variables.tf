variable "sg_ingress_cnt" {
  type    = number
  default = 3
}

variable "ing_port_range" {
  type        = list(number)
  default     = [22, 80, 5000, 3000]
  description = "List of SG Inbound rules destination"
}

variable "protocol" {
  type    = list(string)
  default = ["tcp", "udp"]
}

variable "sg_egress_cnt" {
  type    = number
  default = 1
}

variable "eg_port_range" {
  type        = list(number)
  default     = [0]
  description = "List of SG Outbound rules destination"
}


