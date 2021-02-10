provider "aws" {
    region     = "ap-southeast-1"
    access_key = "AKIAVE76XFKW77RLCH27"
    secret_key = "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"
}

# using data sources 
data "aws_vpc" "default-vpc" {
    default = true
}
output "name" {
    value = data.aws_vpc.default-vpc
}