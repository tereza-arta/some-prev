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
  name = "Sg-${count.index}"
  description = "Custom SG"
  vpc_id = aws_vpc.vpc.id
}

resource "aws_vpc_security_group_ingress_rule" "ing" {
  count = length(var.sg_ingress)
  security_group_id = aws_security_group.for_ecs[count.index].id

  from_port = var.sg_ingress[count.index].from
  to_port = var.sg_ingress[count.index].to
  ip_protocol = var.sg_ingress[count.index].proto
  cidr_ipv4 = var.sg_ingress[count.index].cidr == 3000 ? null : var.sg_ingress[count.index].cidr
  description = var.sg_ingress[count.index].desc
  referenced_security_group_id = var.sg_ingress[count.index].from == 3000 ? aws_security_group.for_lb.id : null
  
  tags = {
    Name = "Some sg ingress tag"
  }
}

resource "aws_vpc_security_group_egress_rule" "eg" {
  count = length(var.sg_egress)
  security_group_id = aws_security_group.for_ecs[count.index].id

  from_port = var.sg_egress[count.index].from
  to_port = var.sg_egress[count.index].to
  ip_protocol = var.sg_egress[count.index].proto
  cidr_ipv4 = var.sg_egress[count.index].cidr
  description = var.sg_egress[count.index].desc
}




#resource "aws_security_group_rule" {
#  count = length(var.sg_ingress)
#  type = "ingress"
#  from_port = var.sg_ingress[count.index].from
#  to_port = var.sg_ingress[count.index].to
#  protocol = var.sg_ingress[count.index].proto
#  cidr_blocks = var.sg_ingress[count.index].cidr
#  description = var.sg_ingress[count.index].desc
#}
# 
#resource "aws_security_group_rule" {
#  type = "egress"
#  from_port = 0;
#  to_port = 0;
#  protocol = "-1"
#  cidr_blocks = var.default_gateway
#}

#  ingress {
#    count = length(var.sg_ingress)
#    from_port = var.sg_ingress[count.index].from
#    to_port = var.sg_ingress[count.index].to
#    protocol = var.sg_ingress[count.index].proto
#    cidr_blocks = var.sg_ingress[count.index].cidr
#    description = var.sg_ingress[count.index].desc
#  }

#  ingress {
#    for_each = var.sg_ingress
#    description = each.value.desc
#    from_port = each.value.from
#    to_port = each.value.to
#    protocol = each.value.proto
#    cidr_blocks = each.value.cidr == 3000 ? [] : [var.defult_gateway]
#    security_groups = each.value.from == 3000 ? [aws_security_group.for_lb.id] : []
#  }

#  egress {
#    description = "SG egress protocol"
#    protocol = var.egress_proto
#    from_port = var.egress_port
#    to_port = var.egress_port
#    cidr_blocks = [var.default_gateway]
#  }
#
#}

