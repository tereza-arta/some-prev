resource "aws_security_group" "for_lb" {
  name = "lb-sg"
  description = "Custom SG for LB"
  vpc_id = aws_vpc.vpc.id

  ingress {
    description = "Allow-${var.fnt_port}-port-for-lb-incoming"
    from_port = var.fnt_port
    to_port = var.fnt_port
    protocol = var.lb_ing_proto[var.proto_ind]
    cidr_blocks = [var.default_gateway]
  }

  egress {
    from_port = 0
    to_port = 0
    protocol = "-1"
    cidr_blocks = [var.default_gateway]
  }
}

resource "aws_security_group" "for_ecs" {
  count = var.sg_cnt
  name = "sg-${count.index}"
  description = "Custom SG"
  vpc_id = aws_vpc.vpc.id

  ingress {
    for_each = var.sg_ingress
    description = each.value.desc
    from_port = each.value.from
    to_port = each.value.to
    protocol = each.value.proto
    cidr_blocks = each.value.cidr == 3000 ? [] : [var.defult_gateway]
    security_groups = each.value.from == 3000 ? [aws_security_group.for_lb.id] : []
  }

  egress {
    description = "SG egress protocol"
    protocol = var.egress_proto
    from_port = var.egress_port
    to_port = var.egress_port
    cidr_blocks = [var.default_gateway]
  }

}

