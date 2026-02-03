variable "project_name" {
  description = "Project name prefix"
  type        = string
  default     = "driveai-devops"
}

variable "instance_type" {
  description = "EC2 instance type"
  type        = string
  default     = "t2.micro"
}
