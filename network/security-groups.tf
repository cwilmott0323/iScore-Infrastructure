resource "aws_security_group" "allow_bastion" {
  name        = "allow_bastion"
  description = "SG for bastion host. SSH access only"
  vpc_id      = aws_vpc.iscore-vpc.id

  ingress {
    description = "SG for bastion host. SSH access only"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  tags = {
    Name = "sg_bastion"
  }
}

resource "aws_security_group" "allow_all" {
  name        = "allow_all"
  description = "SG for bastion host. SSH access only"
  vpc_id      = aws_vpc.iscore-vpc.id

  ingress {
    description = "SG for bastion host. SSH access only"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  tags = {
    Name = "sg_bastion"
  }
}