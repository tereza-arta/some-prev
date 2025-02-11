variable "enable_net" {
  type = bool
  default = false
  description = "Enable network module or not"
}

variable "enable_lb" {
  type = bool
  default = false
  description = "Enable load-balancer module or not"
}

variable "enable_ecr" {
  type = bool
  default = true
  description = "Enable ecr module or not"
}
