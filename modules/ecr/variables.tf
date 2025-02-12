variable "ecr_cnt" {
  type = number
  default = 3
  description = "Count of ecr repos for app components"
}

variable "repo_name" {
  type = list(string)
  default = ["db-img", "srv-img", "fnt-img"]
}

variable "df_context" {
  type = list(string)
  default = ["app/db", "app/srv", "app/fnt"]
  description = "Relative path of appropriate app-component Dockerfilei"
}
