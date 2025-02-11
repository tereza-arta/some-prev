variable "elb_name" {
  default = "Custom-lb"
}

variable "pub_subnets" {
  #type        = any
  description = "Get id from Public Subnets"
}

variable "sec_group" {
  type        = any
  description = "Get id from appropriate(lb) sec-group" 
}

variable "listener_port" {
  type    = number
  default = 80
}

variable "listener_protocol" {
  default = "http"
}

variable "healthy_threshold" {
  type    = number
  default = 2
}

variable "unhealthy_threshold" {
  type    = number
  default = 2
}

variable "check_timeout" {
  type    = number
  default = 3
}

variable "check_target" {
  default = "HTTP:80/"
}

variable "check_interval" {
  type    = number
  default = 30
}

variable "cross_zone" {
  type    = bool
  default = true
}

variable "connection_draining" {
  type    = bool
  default = true
}

variable "draining_timeout" {
  type    = number
  default = 400
}

variable "elb_tag" {
  default = "Custom-alb"
}
