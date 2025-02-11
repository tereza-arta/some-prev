resource "aws_elb" "lb" {
  name            = var.elb_name
  subnets         = [var.pub_subnets]
  security_groups = [var.sec_group]

  listener {
    instance_port     = var.listener_port
    instance_protocol = var.listener_protocol
    lb_port           = var.listener_port
    lb_protocol       = var.listener_protocol
  }

  health_check {
    healthy_threshold   = var.healthy_threshold
    unhealthy_threshold = var.unhealthy_threshold
    timeout             = var.check_timeout
    target              = var.check_target
    interval            = var.check_interval
  }

  cross_zone_load_balancing   = var.cross_zone
  connection_draining         = var.connection_draining
  connection_draining_timeout = var.draining_timeout

  tags = {
    Name = var.elb_tag
  }
}
