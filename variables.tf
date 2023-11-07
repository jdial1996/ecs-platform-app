variable "vpc_id" {
  description = "The id of the VPC that the application will be deployed into."
  type        = string
  default     = "vpc-0bd32988101c051fa"
}

variable "private_subnet_ids" {
  description = "The subnet ids for the Fargate Deployment."
  type        = list(string)
  default = [
    "subnet-04d668bcd9ea26596",
    "subnet-092465aa575f2e0a4",
    "subnet-008af81b7dfc678c8",
  ]
}

variable "public_subnet_ids" {
  description = "The subnet ids for the Fargate Deployment."
  type        = list(string)
  default = [
    "subnet-0db3a3291ca2efac7",
    "subnet-0e2d5de158fed2fc7",
    "subnet-04710f8fc26678a21",
  ]
}

variable "desired_count" {
  description = "The desired number of ECS tasks to have running at one time."
  type        = number
  default     = 1
}

variable "cluster_arn" {
  description = "The ARN of the ECS cluster to deploy the ECS service into."
  type        = string
  default     = "arn:aws:ecs:eu-west-1:355285117207:cluster/my-cluster"
}

variable "service_name" {
  description = "The name of the ECS service."
  type        = string
  default     = "platform-app"

}

variable "image_name" {
  description = "The name of the docker image to deploy."
  type        = string
  default     = "platform-app"
}

variable "image_tag" {
  description = "The version of the image to use (image tag)."
  type        = string
  default     = "703575f0dc792fb0ed345f2fbfadb3385c8b42d5"
}

variable "command" {
  description = "The startup command to pass to the Task."
  type        = list(string)
  default     = []
}


variable "ecs_task_exeuction_role" {
  description = "The IAM role ARN that allows ECS nodes and the docker daemon to make AWS API calls."
  default     = "arn:aws:iam::355285117207:role/test-role"
  type        = string
}

variable "flask_app_port" {
  description = "The port that the Flask Docker container is lisetning on"
  type        = number
  default     = 5000
}