resource "aws_subnet" "private" {
  availability_zone = "us-east-2a"
  vpc_id            = aws_vpc.iscore-vpc.id
  cidr_block        = "172.2.0.0/28"

  tags = {
    Name = "private"
  }
}

resource "aws_subnet" "public" {
  availability_zone = "us-east-2a"
  vpc_id            = aws_vpc.iscore-vpc.id
  cidr_block        = "172.2.0.16/28"

  tags = {
    Name = "public"
  }
}

resource "aws_subnet" "rds-1" {
  availability_zone = "us-east-2a"
  vpc_id            = aws_vpc.iscore-vpc.id
  cidr_block        = "172.2.0.32/28"

  tags = {
    Name = "rds1"
  }
}

resource "aws_subnet" "rds-2" {
  availability_zone = "us-east-2b"
  vpc_id            = aws_vpc.iscore-vpc.id
  cidr_block        = "172.2.0.48/28"

  tags = {
    Name = "rds2"
  }
}