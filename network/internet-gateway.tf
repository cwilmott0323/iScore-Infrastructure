resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.iscore-vpc.id

  tags = {
    Name = "iScore-IGW"
  }
}
