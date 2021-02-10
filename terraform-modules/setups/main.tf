provider "aws" {
    alias      = "SG"
    region     = "ap-southeast-1"
}

provider "aws" {
    alias  = "US"
    region = "us-east-1" 
}

resource "aws_vpc" "main" {
    cidr_block = "10.0.0.0/16"
    tags       = {
        Name  = "ian_webserver_vpc"
    }
}

module "ian_webserver_SG" {
    source         = "../modules/webserver"
    vpc_id         = aws_vpc.main.id
    cidr_block     = "10.0.0.0/16"
    webserver_name = "ian_SG"
    ami            = "ami-06fb5332e8e3e577a"
    instance_type  = "t2.micro"
}

module "ian_webserver_US" {
    source         = "../modules/webserver"
    providers      = {
      aws = aws.US
    }
    vpc_id         = aws_vpc.main.id
    cidr_block     = "10.0.0.0/16"
    webserver_name = "ian_US"
    # ami is unqiue to each availability zone
    ami            = "ami-00ddb0e5626798373"
    instance_type  = "t2.micro"
}

# export the output about instance details from module
output "instance_details" {
    value = module.ian_webserver_SG.instance
}

# export the output about subnet details from module
output "subnet_details" {
    value = module.ian_webserver_SG.subnet
}

resource "aws_elb" "main" {
    subnets   = [module.ian_webserver_SG.subnet.id]
    instances = [module.ian_webserver_SG.instance.id]

    listener {
        instance_port     = 8000
        instance_protocol = "http"
        lb_port           = 80
        lb_protocol       = "http"
    }

    listener {
        instance_port      = 8000
        instance_protocol  = "http"
        lb_port            = 443
        lb_protocol        = "https"
    }
}

