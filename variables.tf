variable "enable_net" {
  type = bool
  default = true
  description = "Enable network module or not"
}

variable "enable_lb" {
  type = bool
  default = true
  description = "Enable load-balancer module or not"
}
