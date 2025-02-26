module "net" {
  source = "./modules/net"
  count = var.enable_net ? 1 : 0
  
}

module "lb" {
  source = "./modules/lb"
  count = var.enable_lb ? 1 : 0

  vpc_id = module.net[0].vpc_id
  lb_sg = module.net[0].lb_sg_id
  subnets = module.net[0].pub_sub_id
}

module "rds" {
  source = "./modules/rds"
  count = var.enable_rds ? 1 : 0

  vpc = module.net[0].vpc_id
}

module "ecr" {
  source = "./modules/ecr"
  count = var.enable_ecr ? 1 : 0

  repo_name = "srv"
  df_context = "app/srv"

  #api_url = null
}

module "ecs" {
  source = "./modules/ecs"
  count = var.enable_ecs ? 1 : 0

  repo_url = module.ecr[0].repo_url
  task_def_name = "srv-task-def"
  app_port = 5000
  db_username = module.rds[0].username
  db_password = module.rds[0].password
  db_name = module.rds[0].db_name
  db_host = module.rds[0].rds_0_endpoint
  vpc_id = module.net[0].vpc_id
  svc_name = "srv-svc"

  cluster_id = null

  tg_arn = module.lb[0].tg_arn_1
  cnt_name = "svc-cnt"
  cnt_port = 5000
}

##Second ECR module execution
#module "ecr-sec" {
#  source = "./modules/ecr"
#  count = var.enable_ecr ? 1 : 0
#
#  repo_name = "fnt"
#  build_arg = true
#  df_context = "app/fnt"
#  api_url = module.lb[0].dns_name_1
#
#  depends_on = [ module.lb[0], module.ecs[0] ]
#}
#
####Second ECS module execution
#module "ecs-sec" {
#  source = "./modules/ecs"
#  count = var.enable_ecs ? 1 : 0
#
#  role_name = "execRoleSecond"
#  cluster_name = "bla"
#  task_def_name = "fnt-task-def"
#  app_port = 3000  
#  cluster_id_from_var = true
#  cluster_id = module.ecs[0].cluster_id
#
#  repo_url = module.ecr[0].repo_url
#  vpc_id = module.net[0].vpc_id
#  svc_name = "fnt-svc"
#  cluster_cnt = 1
#
#  tg_arn = module.lb[0].tg_arn_2
#  cnt_name = "fnt-cnt"
#  cnt_port = 3000
#
#
#  db_username = null
#  db_password = null
#  db_name = null
#  db_host = null
#
#  depends_on = [module.ecr-sec[0]]
#}
