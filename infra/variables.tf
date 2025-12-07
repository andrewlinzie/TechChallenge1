variable "account_id" {
  type        = string
  description = "AWS Account ID"
}

variable "region" {
  type        = string
  description = "AWS Region"
}

variable "backend_image" {
  type        = string
  description = "Full ECR image URL for backend"
}

variable "frontend_image" {
  type        = string
  description = "Full ECR image URL for frontend"
}
