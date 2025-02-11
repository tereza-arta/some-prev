resource "aws_ecr_repository" "different" {
  count = var.ecr_cnt
  name = var.repo_name[count.index]
  image_tag_mutability = "MUTABLE"
}

data "aws_caller_identity" "current" {}

resource "aws_ecr_lifecycle_policy" "example" {
  count = var.ecr_cnt
  repository = aws_ecr_repository.different[count.index].name

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

resource "terraform_data" "docker_packaging" {
  count = var.ecr_cnt

  provisioner "local-exec" {
    command = <<EOF
    aws ecr get-login-password --region eu-north-1 | docker login --username AWS --password-stdin ${data.aws_caller_identity.current.account_id}.dkr.ecr.eu-north-1.amazonaws.com
    docker build -t "${aws_ecr_repository.different[count.index].repository_url}:latest" -f "${var.df_context[count.index]}/Dockerfile" .
    docker push "${aws_ecr_repository.different[count.index].repository_url}:latest"
    EOF
  }


  triggers_replace = {
    "run_at" = timestamp()
  }


  depends_on = [aws_ecr_repository.different]
}
