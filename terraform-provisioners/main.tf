provider "aws" {
    region     = "ap-southeast-1"
    access_key = "AKIAVE76XFKW77RLCH27"
    secret_key = "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"
}

resource "aws_instance" "web" {
    ami           = "ami-06fb5332e8e3e577a"
    instance_type = "t2.micro"
    key_name      = "Ian"

    tags = {
        Name = "Test"
    }

    # # execute storing of public ip into .txt file on local machine
    # provisioner "local-exec" {
    #     command = "echo ${self.public_ip} > public-ip.txt" 
    # }

    # ************************************************************************

    # used to copy files or directories from the machine executing Terraform to the newly created resource
    provisioner "file" {
        content = "foobar"
        destination = "/home/ubuntu/testfile.txt"
    }

    # specify ssh connection 
    # run ssh -i "/home/ian/Downloads/personal-keypair.pem" <user>@<public_ip>
    connection {
        type = "ssh"
        host = self.public_ip
        user = "ubuntu"
        private_key = file("/home/ian/Downloads/personal-keypair.pem")
    }

    # ************************************************************************

    # # execute creation of .txt file on remote machine
    # provisioner "remote-exec" {
    #     inline = [
    #         "touch /home/ubuntu/foobar.txt"
    #     ]
    # }   
}

output "public-ip" {
    value = aws_instance.web.public_ip
}