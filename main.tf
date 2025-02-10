#locals
locals {
  in_ports = [
    80,
    5432,
    5000,
    3000
  ]

  out_ports = [
    0
  ]
}

#Net resources
resource "aws_vpc" "vpc" {
  cidr_block = "10.0.0.0/16"
  tags = {
    Name = "Custom VPC"
  }
}

resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.vpc.id
  tags = {
    Name = "Custom Internet Gateway"
  }
}

resource "aws_subnet" "pub-sub" {
  vpc_id = aws_vpc.vpc.id
  cidr_block = "10.0.0.0/24"
  map_public_ip_on_launch = true
  tags = {
    Name = "Custom Public Subnet"
  }
}

resource "aws_route_table" "public" {
  vpc_id = aws_vpc.vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }
  tags = {
    Name = "Custom RT for public"
  }
}

resource "aws_route_table_association" "rt-sub-ass"{
  subnet_id = aws_subnet.pub-sub.id
  route_table_id = aws_route_table.public.id
}

resource "aws_security_group" "for-lb" {
  count = var.lb_sg_cnt
  name = "lb-sg-${count.index}"
  description = "Custom SG for LB"
  vpc_id = aws_vpc.vpc.id

  ingress {
    count = var.lb_sg_ing_cnt
    description = "Allow-${var.lb_sg_ing_cnt[count.index]}-port-for-lb-incoming"
    from_port = var.lb_sg_ing_port[count.index]
    to_port = var.lb_sg_ing_port[count.index]
    protocol = var.protocol[var.lb_protocol_ind]
    cidr_blocks = [var.default_gateway]
  }

  egress {
    from_port = 0
    to_port = 0
    protocol = "-1"
    cidr_blocks = [var.default_gateway]
  }
}

resource "aws_security_group" "for-ecs" {
  count = var.sg_cnt
  name = "sg-${count.index}"
  description = "Custom SG"
  vpc_id = aws_vpc.vpc.id

  dynamic "ingress" {
  for_each = toset(local.in_ports)
  content {
    from_port = ingress.value
    to_port = ingress.value
    protocol = "tcp"
   # count = length(var.ing_port_range)
   # description = "Allow-${var.sg_ing_cnt[count.index]}-port-for-incoming-traffic"
   # from_port = var.ing_port_range[count.index]
   # to_port = var.ing_port_range[count.index]
   # protocol = var.protocol[var.lb_protocol_ind]
   # cidr_blocks = [var.default_gateway]
  }

  egress {
    from_port = 0
    to_port = 0
    protocol = "-1"
    cidr_blocks = [var.default_gateway]
  }
}

#ECR resources
resource "aws_ecr_repository" "for-db" {
  name = "db"
  image_tag_mutability = "MUTABLE"
}

data "aws_caller_identity" "current" {}

resource "aws_ecr_lifecycle_policy" "example" {
  repository = aws_ecr_repository.for-db.name

  policy = <<EOF
{
    "rules": [
        {
            "rulePriority": 1,
            "description": "Keep last 3 images",
            "selection": {
                "tagStatus": "any",
                "countType": "imageCountMoreThan",
                "countNumber": 3
            },
            "action": {
                "type": "expire"
            }
        }
    ]
}
EOF
}

resource "null_resource" "docker_packaging" {
	
	  provisioner "local-exec" {
	    command = <<EOF
	    aws ecr get-login-password --region eu-north-1 | docker login --username AWS --password-stdin ${data.aws_caller_identity.current.account_id}.dkr.ecr.eu-north-1.amazonaws.com
	    docker build -t "${aws_ecr_repository.for-db.repository_url}:latest" -f db/Dockerfile .
	    docker push "${aws_ecr_repository.for-db.repository_url}:latest"
	    EOF
	  }
	

	  triggers = {
	    "run_at" = timestamp()
	  }
	

	  depends_on = [
	    aws_ecr_repository.for-db,
	  ]
}

#resource "aws_security_group" "sg" {
#  name        = "Custom SG"
#  description = "SG for public"
#  vpc_id      = aws_vpc.vpc.id
#
#  tags = {
#    Name = "Custom SG "
#  }
#}
#
#resource "aws_vpc_security_group_ingress_rule" "example" {
#  count             = var.sg_ingress_cnt
#  description       = "Allow-${var.ing_port_range[count.index]}-port-for-incoming-traffic"
#  security_group_id = aws_security_group.sg.id
#  cidr_ipv4         = "0.0.0.0/0"
#  from_port         = var.ing_port_range[count.index]
#  ip_protocol       = var.protocol[0]
#  to_port           = var.ing_port_range[count.index]
#}
#
#resource "aws_vpc_security_group_egress_rule" "example" {
#  count             = var.sg_egress_cnt
#  description       = "Allow-${var.eg_port_range[count.index]}-port-for-incoming-traffic"
#  security_group_id = aws_security_group.sg.id
#  cidr_ipv4         = "0.0.0.0/0"
#  from_port         = var.eg_port_range[0]
#  ip_protocol       = "-1"
#  to_port           = var.eg_port_range[0]
#}
