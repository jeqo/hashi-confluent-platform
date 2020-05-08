provider "aws" {
  profile    = "default"
  region     = "us-east-2"
}

resource "aws_instance" "zk1" {
  ami           = "ami-06d7d274b75b7bfa9"
  instance_type = "t2.micro"
}
