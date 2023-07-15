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
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
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

resource "aws_instance" "linux_server_v2" {
  ami                    = data.aws_ami.amazon_linux_2_kernel_5.id
  instance_type          = var.linux_instance_type
  subnet_id              = data.aws_subnets.default.ids[3]
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

resource "aws_instance" "instance_type_quest_server" {
  ami                    = data.aws_ami.amazon_linux_2_kernel_5.id
  instance_type          = var.linux_instance_type
  subnet_id              = data.aws_subnets.default.ids[3]
  vpc_security_group_ids = [aws_security_group.aws_linux_sg.id]
  user_data              = file("instance-type-user-data.sh")

  root_block_device {
    volume_size           = 8
    volume_type           = var.linux_root_volume_type
    delete_on_termination = true
    encrypted             = true
  }
}

output "instance_type_quest_server_public_ip" {
  value = aws_instance.instance_type_quest_server.public_ip
}

output "instance_type_quest_server_public_dns" {
  value = aws_instance.instance_type_quest_server.public_dns
}
