#   RANDOM RESOURCE, WHICH DETERMINE MAXIMUM AND MINIMUM VPC TO BE CREATED
data "aws_availability_zones" "available" {}

resource "random_integer" "random" {
  min = 1
  max = 100
}

resource "random_shuffle" "az_list" {
  input        = data.aws_availability_zones.available.names
  result_count = var.max_subnets
}

resource "aws_vpc" "mtc_vpc" {
  cidr_block           = var.vpc_cidr
  enable_dns_hostnames = true
  enable_dns_support   = true
  tags = {
    Name = "mtc_vpc -${random_integer.random.id}"
  }
  lifecycle {
    create_before_destroy = true
  }
}


resource "aws_subnet" "mtc_public_subnet" {
  count                   = var.public_sn_count
  vpc_id                  = aws_vpc.mtc_vpc.id
  cidr_block              = var.public_cidrs[count.index]
  map_public_ip_on_launch = true
  availability_zone       = random_shuffle.az_list.result[count.index]
  #availability_zone = data.aws_availability_zones.available.names[count.index]
  #availability_zone = ["us-west-2a", "us-west-2b", "us-west-2c", "us-west-2d"][count.index]

  tags = {
    Name = "mtc_public_subnet-${count.index + 1}"
  }
}

resource "aws_route_table_association" "mtc_public_assoc" {
  count          = var.public_sn_count
  subnet_id      = aws_subnet.mtc_public_subnet.*.id[count.index]
  route_table_id = aws_route_table.mtc_public_rt.id
}


resource "aws_subnet" "mtc_private_subnet" {
  count                   = var.private_sn_count
  vpc_id                  = aws_vpc.mtc_vpc.id
  cidr_block              = var.private_cidrs[count.index]
  map_public_ip_on_launch = false
  availability_zone       = random_shuffle.az_list.result[count.index]
  #availability_zone = data.aws_availability_zones.available.names[count.index]
  #availability_zone = ["us-west-2a", "us-west-2b", "us-west-2c", "us-west-2d"][count.index]

  tags = {
    Name = "mtc_private_subnet-${count.index + 1}"
  }
}

resource "aws_internet_gateway" "mtc_internet_gateway" {
  vpc_id = aws_vpc.mtc_vpc.id
  tags = {
    name = "mtc_igw"
  }
}

resource "aws_route_table" "mtc_public_rt" {
  vpc_id = aws_vpc.mtc_vpc.id
  tags = {
    name = "mtc_public_rt"
  }
}

resource "aws_route" "default_route" {
  route_table_id         = aws_route_table.mtc_public_rt.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.mtc_internet_gateway.id
}

resource "aws_default_route_table" "mtc_private_rt" {
  default_route_table_id = aws_vpc.mtc_vpc.default_route_table_id
  tags = {
    Name = "mtc_private_rt"
  }

}

resource "aws_security_group" "mtc_sg" {
  for_each    = var.security_groups
  name        = each.value.name
  description = each.value.description
  vpc_id      = aws_vpc.mtc_vpc.id

  dynamic "ingress" {
    for_each = each.value.ingress
    content {
      description = ingress.value.description
      from_port   = ingress.value.from
      to_port     = ingress.value.to
      protocol    = ingress.value.protocol
      cidr_blocks = ingress.value.cidr_blocks
    }
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1" # -1 means any protocol
    cidr_blocks = ["0.0.0.0/0"]
    #ipv6_cidr_blocks = ["::/0"]
  }

  tags = {
    Name = "public-sg"
  }
}

resource "aws_security_group" "rds_sg" {
  for_each    = var.rds_security_groups
  name        = each.value.name
  description = each.value.description
  vpc_id      = aws_vpc.mtc_vpc.id

  dynamic "ingress" {
    for_each = each.value.ingress
    content {
      description = ingress.value.description
      from_port   = ingress.value.from
      to_port     = ingress.value.to
      protocol    = ingress.value.protocol
      cidr_blocks = ingress.value.cidr_blocks
    }
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1" # -1 means any protocol
    cidr_blocks = ["0.0.0.0/0"]
    #ipv6_cidr_blocks = ["::/0"]
  }

  tags = {
    Name = "private-sg"
  }
}

resource "aws_db_subnet_group" "mtc_rds" {
  count      = var.db_subnet_group == true ? 1 : 0
  name       = "mtc_rds_subnetgroup"
  subnet_ids = aws_subnet.mtc_private_subnet.*.id
  tags = {
    Name = "mtc_rds_sng"
  }
}

