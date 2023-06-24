data "aws_vpc" "default" {
  default = true
}

data "aws_subnets" "default" {
  filter {
    name   = "vpc-id"
    values = [data.aws_vpc.default.id]
  }
}

data "aws_ami" "amazon_linux_2_kernel_5" {
  most_recent = true
  owners      = ["amazon"]
  filter {
    name   = "name"
    values = ["amzn2-ami-kernel-5*"]
  }
}

output "linux_ami_id" {
  value = data.aws_ami.amazon_linux_2_kernel_5.id
}

resource "aws_security_group" "aws_linux_sg" {
  name   = "linux-sg"
  vpc_id = data.aws_vpc.default.id
  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
    description = "Allow incoming HTTP connections"
  }
}

resource "aws_instance" "linux_server" {
  ami                    = data.aws_ami.amazon_linux_2_kernel_5.id
  instance_type          = var.linux_instance_type
  subnet_id              = data.aws_subnets.default.ids[0]
  vpc_security_group_ids = [aws_security_group.aws_linux_sg.id]
  user_data              = file("aws-user-data.sh")

  root_block_device {
    volume_size           = 8
    volume_type           = var.linux_root_volume_type
    delete_on_termination = true
    encrypted             = true
  }
}

output "linux_server_public_dns" {
  value = aws_instance.linux_server.public_dns
}

output "linux_server_public_ip" {
  value = aws_instance.linux_server.public_ip
}
