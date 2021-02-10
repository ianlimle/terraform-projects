provider "aws" {
    region     = "ap-southeast-1"
}

# using data sources 
data "aws_vpc" "default-vpc" {
    default = true
}
output "name" {
    value = data.aws_vpc.default-vpc
}