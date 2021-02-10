provider "aws" {
    region     = "ap-southeast-1"
    access_key = "AKIAVE76XFKW77RLCH27"
    secret_key = "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"
}

# using dynamic blocks as for loops to reduce repeated code
locals {
    ingress_rules = [{
        port        = 443,
        description = "Port 443"
    },
    {
        port        = 80,
        description = "Port 80"
    }]
}

data "aws_vpc" "main" {
    default = true
}

resource "aws_security_group" "main" {
    name   = "main-security-group"
    vpc_id = data.aws_vpc.main.id

    # using dynamic blocks as for loops to reduce repeated code
    dynamic "ingress" {
        for_each = local.ingress_rules
        content {
            description = ingress.value.description
            from_port   = ingress.value.port
            to_port     = ingress.value.port
            protocol    = "tcp"
            cidr_blocks = ["0.0.0.0/0"]
        }
    }
}