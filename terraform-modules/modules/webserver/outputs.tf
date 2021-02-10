output "instance" {
     value = aws_instance.webserver
     description = "Webserver instance details"
}

output "subnet" {
    value = aws_subnet.webserver
    description = "Webserver subnet details"
}