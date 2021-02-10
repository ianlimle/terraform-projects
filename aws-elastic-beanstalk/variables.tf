variable "region" {
    description = "AWS region"
    default     = "ap-southeast-1"
}

variable "subnet_prefix" {
    description = "cidr block for the subnet"
    default     = [{cidr_block = "10.0.1.0/24", name = "prod_subnet"}, 
                   {cidr_block = "10.0.2.0/24", name = "dev_subnet"}]
}

variable "ebs_app_name" {
    description = "name of elastic beanstalk application"
    default     = "user-app"
}

variable "ebs_env_name" {
    description = "name of elastic beanstalk environment"
    default     = "prod"
}

variable "ebs_name" {
    description = "solution name"
    default     = "Go app"
}

variable "ebs_namespace" {
    description = "namespace of elastic beanstalk environment"
    default     = "Capstone"
}

variable "ebs_stage" {
    description = "stage of elastic beanstalk environment"
    default     = "prod"
}
