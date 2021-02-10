provider "aws" {
    region     = "ap-southeast-1"
    access_key = "AKIAVE76XFKW77RLCH27"
    secret_key = "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"
}

# resource "<provider>_<resource_type>" "name" {
#     config options ...
#     key = "value"
# }

# 1. create vpc
resource "aws_vpc" "prod_vpc" {
    cidr_block = "10.0.0.0/16"
    tags       = {
        Name = "production"
    } 
}

# 2. create internet gateway
resource "aws_internet_gateway" "prod_gw" {
    vpc_id = aws_vpc.prod_vpc.id
    tags   = {
        Name = "production"
    } 
}

# 3. create custom route table
resource "aws_route_table" "prod_route_table" {
    vpc_id = aws_vpc.prod_vpc.id
    
    route {
        cidr_block = "0.0.0.0/0"
        gateway_id = aws_internet_gateway.prod_gw.id
    }

    route {
        ipv6_cidr_block        = "::/0"
        gateway_id             = aws_internet_gateway.prod_gw.id
    }

    tags = {
        Name = "production"
    }
}

variable "subnet_prefix" {
    description = "cidr block for the subnet"
}

# 4. create a subnet
resource "aws_subnet" "subnet_1" {
    vpc_id            = aws_vpc.prod_vpc.id
    cidr_block        = var.subnet_prefix[0].cidr_block
    availability_zone = "ap-southeast-1c"
    
    tags = {
        Name = var.subnet_prefix[0].name
    }
}

# 4. create a 2nd subnet
resource "aws_subnet" "subnet_2" {
    vpc_id            = aws_vpc.prod_vpc.id
    cidr_block        = var.subnet_prefix[1].cidr_block 
    availability_zone = "ap-southeast-1c"
    
    tags = {
        Name = var.subnet_prefix[1].name
    }
}

# 5. associate subnet with route table
resource "aws_route_table_association" "a" {
    subnet_id      = aws_subnet.subnet_1.id
    route_table_id = aws_route_table.prod_route_table.id
}

# 6. create security group to allow port 22, 80, 443
resource "aws_security_group" "allow_web" {
    name        = "allow_web_traffic"
    description = "Allow TLS inbound traffic"
    vpc_id      = aws_vpc.prod_vpc.id

    ingress {
        description = "HTTPS traffic"
        from_port   = 443
        to_port     = 443
        protocol    = "tcp"
        cidr_blocks  = ["0.0.0.0/0"]
    }

    ingress {
        description = "HTTP traffic"
        from_port   = 80
        to_port     = 80
        protocol    = "tcp"
        cidr_blocks  = ["0.0.0.0/0"]
    }

    ingress {
        description = "SSH traffic"
        from_port   = 22
        to_port     = 22
        protocol    = "tcp"
        cidr_blocks  = ["0.0.0.0/0"]
    }

    egress {
        cidr_blocks = [ "0.0.0.0/0" ]
        from_port = 0
        protocol = -1
        to_port = 0
    }

    tags = {
        Name = "production"
    } 
}

# 7. create a network interface with an ip in the subnet
resource "aws_network_interface" "prod_web_server" {
    subnet_id       = aws_subnet.subnet_1.id
    private_ips     = ["10.0.1.50"]
    security_groups = [aws_security_group.allow_web.id]
}

# 8. assign an elastic ip to the network interface
resource "aws_eip" "prod_eip" {
    vpc                       = true
    network_interface         = aws_network_interface.prod_web_server.id
    associate_with_private_ip = "10.0.1.50"
    depends_on = [aws_internet_gateway.prod_gw]
}

# print out public server ip for reference
output "server_public_ip" {
    value = aws_eip.prod_eip.public_ip
}

# 9. create ubuntu server and install/enable apache2
resource "aws_instance" "prod_web_server_instance" {
    ami               = "ami-06fb5332e8e3e577a"
    instance_type     = "t2.micro"
    availability_zone = "ap-southeast-1c"
    key_name = "personal-keypair"

    network_interface {
        device_index = 0
        network_interface_id = aws_network_interface.prod_web_server.id
    }

    user_data = <<-EOF
                #!/bin/bash
                sudo apt update -y
                sudo apt install apache2 -y
                sudo systemctl start apache2
                sudo bash -c 'echo your very first web server > /var/www/html/index.html'
                EOF

    tags = {
        Name = "web_server"
    }
}

output "server_private_ip" {
    value = aws_instance.prod_web_server_instance.private_ip
}

output "server_id" {
    value = aws_instance.prod_web_server_instance.id
}

