resource "aws_vpc" "vpc" {
  cidr_block = var.vpc_cidr
  instance_tenancy = var.tenancy
  enable_dns_support = var.dns_support
  enable_dns_hostnames = var.dns_hostname
  enable_network_address_usage_metrics = var.addr_usage_metrics

  tags = {
    Name = var.vpc_tag
    Tag  = var.vpc_additional_tag
  }
}
