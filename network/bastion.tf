data "aws_ami" "ubuntu" {
  most_recent = true

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-focal-20.04-amd64-server-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  owners = ["099720109477"] # Canonical
}

resource "aws_instance" "bastion" {
  ami           = data.aws_ami.ubuntu.id
  instance_type = "t3.micro"

  security_groups = [aws_security_group.allow_bastion.id]
  subnet_id = aws_subnet.public.id

  key_name = aws_key_pair.bastion.key_name

  tags = {
    Name = "iScore Bastion"
  }
}

resource "aws_key_pair" "bastion" {
  key_name   = "bastion-key"
  public_key = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQDB6jt4cGvNRtFtPsYx4tENIJmjcs7g7CoHtvOydFn1vOcLLW5LI5jydOdPvagDaI0ql/4RYVTAgv6EvOXqNvaYPKKjqbvfZFUjMKghoILq6qlS16+K/lydF5TNhKyLB1e0yQiDHqOS8bwZqRvWJlUSuR66PMbGrCL17mxjQ7CYlxJKN+o5KdaJkNjwZg8VxUmNg8byPWl5qTjzSuaGy3MA74oA/Aeqo6ipZtiprwI736iyNGV124R9hoA+6UcpJ0di9E5kRJ3xxsZAeM9kH6gmh5gzTjLL5Vbr2Cc/7OTm1X0cCAF5CbMFZ/QBCfF5BA0UaSS83C6EjpVJGLNmgqu9JETUMrzS4J2GcXgL13tSNavcB/03CnL5uM3vJAKCuzrk0BQgPDazF8ytRE808532GKVGzDwwH3EqW1lLWaOYjn6BLJpXhmuvZXKAgDLNQLEZ3NEJKI/masQZ9bRFjI5s/UdPdKCcb65VyrwoW6k8gNjWM4gEae3G0KBjirx6gFU= chriswilmott@Chriss-MBP.lan"
}