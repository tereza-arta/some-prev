module "net" {
  source = "./modules/network"
  count = var.enable_net ? 1 : 0
}

module "lb" {
  source = "./modules/lb"

  count = var.enable_lb ? 1 : 0
  pub_subnets = module.net[0].pub_sub_id
  sec_group = module.net[0].lb_sg_id
}
