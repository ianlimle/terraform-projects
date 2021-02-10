variable "region" {
    description = "AWS region"
    value       = "ap-southeast-1"
}

variable "subnet_prefix" {
    description = "cidr block for the subnet"
    value       = [{cidr_block = "10.0.1.0/24", name = "prod_subnet"}, 
                   {cidr_block = "10.0.2.0/24", name = "dev_subnet"}]
}

variable "ebs_app_name" {
    description = "name of elastic beanstalk application"
    value       = "user-app"
}

variable "ebs_env_name" {
    description = "name of elastic beanstalk environment"
    value       = "prod"
}

