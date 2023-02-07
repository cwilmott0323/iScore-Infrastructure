resource "aws_vpc_ipam" "ipam" {
  operating_regions {
    region_name = var.region
  }
}

resource "aws_vpc_ipam_pool" "iscore-ips" {
  address_family = "ipv4"
  ipam_scope_id  = aws_vpc_ipam.ipam.private_default_scope_id
  locale         = var.region
}

resource "aws_vpc_ipam_pool_cidr" "iscore-ips-cidr" {
  ipam_pool_id = aws_vpc_ipam_pool.iscore-ips.id
  cidr         = "172.2.0.0/16"
}

resource "aws_vpc" "iscore-vpc" {
  ipv4_ipam_pool_id   = aws_vpc_ipam_pool.iscore-ips.id
  ipv4_netmask_length = 24
  depends_on = [
    aws_vpc_ipam_pool_cidr.iscore-ips-cidr
  ]
  tags = {
    Name = "iScore-VPC"
  }
}