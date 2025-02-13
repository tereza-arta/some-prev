data "aws_iam_policy_document" "policy" {
  statement {
    actions = ["sts:AssumeRole"]
    principals {
      type = "Service"
      identifiers = ["ecs-tasks.amazonaws.com"]
    }
  }
}

resource "aws_iam_role" "ecs_task_exec_role" {
  name = var.role_name
  assume_role_policy = "${data.aws_iam_policy_document.policy.json}"
}

resource "aws_iam_role_policy_attachment" "ecs_rp_attach" {
  role = "${aws_iam_role.ecs_task_exec_role.name}"
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonECSTaskExecutionRolePolicy"
}

resource "aws_ecs_cluster" "example" {
  name = var.cluster_name

  tags = {
    Name = "Cluster-for-app"
  }
}

resource "aws_ecs_task_definition" "td" {
  count = length(var.task_def_name)
  family = var.task_def_name[count.index]
  requires_compatibilities = [var.launch_type]
  execution_role_arn = aws_iam_role.ecs_task_exec_role.arn
  network_mode = var.net_mode
  cpu = var.task_cpu
  memory = var.task_memory
  
  container_definitions = jsonencode ([
    {
      name = var.cnt_name[count.index]
      image = "${var.repo_url[count.index]}:${var.image-tag}"
      cpu = var.cnt_cpu
      memory = var.cnt_memory
      essential = var.essential
      portMappings [
        {
          containerPort = var.app_port[count.index]
          hostPort = var.app_port[count.index] 
        }
      ]
    }

  ])
}

data "aws_ecs_task_definition" "td" {
  task_definition = aws_ecs_task_definition.td.family
}

resource "aws_ecs_service" "service" {
  launch_type = var.launch_type
  platform_version = var.platform_version
  cluster = aws_ecs_cluster.example.id
  task_definition = aws_ecs_task_definition.td.arn
  scheduling_strategy = var.scheduling
  desired_count = var.desired_count
  deployment_minimun_healty_percent = var.min_healthy_perc
  deployment_maximum_percent = var.max_perc
  iam_role = aws_iam_role.ecs_task_exec_role.arn

  depends_on = [aws_iam_role.ecs_task_exec_role]

  network_configuration {
    assign_public_ip = var.pub_ip
    security_group = 
    subnets = 
  }
}
