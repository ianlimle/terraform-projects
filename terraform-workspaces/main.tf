provider "aws" {
    region     = var.region
    # access_key = "AKIAVE76XFKW77RLCH27"
    # secret_key = "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"
}

locals {
    instance_name = "${terraform.workspace}-instance"
}

resource "aws_instance" "webserver" {
    ami           = var.ami 
    instance_type = var.instance_type
    tags          = {
        Name = local.instance_name
    }  
}