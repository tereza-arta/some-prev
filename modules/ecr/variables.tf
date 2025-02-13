variable "ecr_cnt" {
  type = number
  default = 3
  description = "Count of ecr repos for app components"
}

variable "repo_name" {
  type = list(string)
  default = ["db-image", "srv-image", "fnt-image"]
}

variable "df_context" {
  type = list(string)
  default = ["app/db", "app/srv", "app/fnt"]
  description = "Relative path of appropriate app-component Dockerfilei"
}

#This must be same in ecs module variables
variable "image-tag" {
  default = "latest"
  description = "Default image tag for all ecr repos"
}
