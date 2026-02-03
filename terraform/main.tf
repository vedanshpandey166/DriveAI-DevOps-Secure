
# Key Pair

resource "aws_key_pair" "app_key" {
  key_name   = "${var.project_name}-key"
  public_key = file("${path.module}/keys/driveai-key.pub")
}


# Security Group

resource "aws_security_group" "app_sg" {
  name        = "${var.project_name}-sg"
  description = "Security group for DriveAI app server"

  ingress {
    description = "SSH"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "HTTP"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "Backend API"
    from_port   = 8000
    to_port     = 8000
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "Frontend UI"
    from_port   = 3000
    to_port     = 3000
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name    = "${var.project_name}-sg"
    Project = var.project_name
  }
}


# EC2 Instance

resource "aws_instance" "app_server" {
  ami                    = "ami-0b6c6ebed2801a5cb" # Ubuntu server AWS (us-east-1)
  instance_type          = var.instance_type
  key_name               = aws_key_pair.app_key.key_name
  vpc_security_group_ids = [aws_security_group.app_sg.id]

  user_data = file("${path.module}/../scripts/install_docker.sh")
  user_data_replace_on_change = true

  root_block_device {
    volume_size = 15
    volume_type = "gp3"
  }


  tags = {
    Name    = "${var.project_name}-app-server"
    Project = var.project_name
  }
}
