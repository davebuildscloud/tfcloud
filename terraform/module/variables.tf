variable "application" {
  description = ""
}

variable "environment" {
  description = ""
}

variable "subnets" {
  description = ""
  type        = "list"
}

variable "ami_id" {
  description = "The ID of the AMI to be used for the instance"
}

variable "user_data" {
  type        = "string"
  description = "(Optional) The user data to be run after provisioning"
  default     = ""
}

variable "key_name" {
  description = "The name of the key used to ssh to the instance"
}

variable "instance_type" {
  description = "the type of instance to launch"
}

variable "vpc_id" {
  description = "The VPC into which resources are deployed"
}
