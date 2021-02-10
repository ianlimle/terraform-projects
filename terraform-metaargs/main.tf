provider "aws" {
    region     = "ap-southeast-1"
    access_key = "AKIAVE76XFKW77RLCH27"
    secret_key = "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"
}

# for each
resource "aws_instance" "web_1" {
    for_each = {
        prod = "t2.large"
        dev  = "t2.micro"
    }

    ami           = "ami-06fb5332e8e3e577a"
    instance_type = each.value

    tags = {
        Name = "Test ${each.key}"
    }
}

# count
resource "aws_instance" "web_2" {
    count         = 2
    ami           = "ami-06fb5332e8e3e577a"
    instance_type = "t2.micro"

    tags = {
        Name = "Test ${count.index}"
    }
}

# lifecycle
resource "aws_instance" "web_3" {
    ami           = "ami-06fb5332e8e3e577a"
    instance_type = "t2.micro"

    tags = {
        Name = "Test for lifecycle"
    }

    lifecycle {
        #create_before_destroy = true
        #prevent_destroy = true
        ignore_changes = [ 
            tags["Name"],
        ]

    }
}
