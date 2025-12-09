variable "region" {
  type    = string
  default = "us-east-2"
}

variable "backend_image" {
  type = string
}

variable "frontend_image" {
  type = string
}

# 👇 This is the key that forces a new ECS Task Definition revision
variable "deploy_id" {
  type = string
}
