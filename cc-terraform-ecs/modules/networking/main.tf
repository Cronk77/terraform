# VPC
resource "aws_vpc" "vpc" {
  cidr_block           = var.cidr
  enable_dns_hostnames = true
  enable_dns_support   = true
  tags                 = {
    Name = "${var.app_name}_vpc"
    Env  = var.env
  }
}

# Internet gateway
resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.vpc.id
  tags   = {
    Name = "${var.app_name}-igw"
    Env  = var.env
  }
}

# Private subnets
resource "aws_subnet" "private_subnet" {
  vpc_id            = aws_vpc.vpc.id
  count             = length(var.private_subnets)
  cidr_block        = element(var.private_subnets, count.index )
  availability_zone = element(var.availability_zones, count.index )

  tags = {
    Name = "${lower(var.app_name)}-private-subnet-${count.index}"
    Env  = var.env
  }
}

# Public subnets
resource "aws_subnet" "public_subnet" {
  vpc_id                  = aws_vpc.vpc.id
  count                   = length(var.public_subnets)
  cidr_block              = element(var.public_subnets, count.index )
  availability_zone       = element(var.availability_zones, count.index )
  map_public_ip_on_launch = true

  tags = {
    Name = "${lower(var.app_name)}-public-subnet-${count.index}"
    Env  = var.env
  }
}

# Public route table
resource "aws_route_table" "public_route_table" {
  vpc_id = aws_vpc.vpc.id
  tags   = {
    Name = "${lower(var.app_name)}public-route-table"
    Env  = var.env
  }
}

# Public route
resource "aws_route" "public-route" {
  route_table_id         = aws_route_table.public_route_table.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.igw.id
}

# Route table association with public subnets
resource "aws_route_table_association" "public-route-association" {
  count          = length(var.public_subnets)
  subnet_id      = element(aws_subnet.public_subnet.*.id, count.index )
  route_table_id = aws_route_table.public_route_table.id
}

# Private route table
resource "aws_route_table" "private_route_table" {
  vpc_id = aws_vpc.vpc.id
  tags   = {
    Name = "${lower(var.app_name)}private-route-table"
    Env  = var.env
  }
}

# Private route
resource "aws_route" "private_route" {
  route_table_id         = aws_route_table.private_route_table.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_nat_gateway.nat_gateway.id
}

# Route table association with private subnets
resource "aws_route_table_association" "private_route_association" {
  count          = length(var.private_subnets)
  subnet_id      = element(aws_subnet.private_subnet.*.id, count.index )
  route_table_id = aws_route_table.private_route_table.id
}

# Nat gateway
resource "aws_nat_gateway" "nat_gateway" {
  allocation_id = aws_eip.eip.id
  subnet_id     = element(aws_subnet.public_subnet.*.id, 0)
  depends_on    = [aws_internet_gateway.igw]
}

# Elastic API for gateway
resource "aws_eip" "eip" {
  vpc = true
}





































# # VPC
# resource "aws_vpc" "vpc" {
#   cidr_block           = var.cidr
#   enable_dns_hostnames = true
#   enable_dns_support   = true
#   tags                 = {
#     Name = "${var.app_name}_vpc"
#     Env  = var.env
#   }
# }

# # Internet gateway
# resource "aws_internet_gateway" "igw" {
#   vpc_id = aws_vpc.vpc.id
#   tags   = {
#     Name = "${var.app_name}-igw"
#     Env  = var.env
#   }
# }

# # Public subnets one
# resource "aws_subnet" "public_subnet_one" {
#   vpc_id                  = aws_vpc.vpc.id
#   count                   = length(var.availability_zones)
#   cidr_block              = var.public_subnet_one
#   availability_zone       = element(var.availability_zones, count.index )
#   map_public_ip_on_launch = true

#   tags = {
#     Name = "${lower(var.app_name)}-public-subnet-one"
#     Env  = var.env
#   }
# }

# # Public subnets two
# resource "aws_subnet" "public_subnet_two" {
#   vpc_id                  = aws_vpc.vpc.id
#   count                   = length(var.availability_zones)
#   cidr_block              = var.public_subnet_two
#   availability_zone       = element(var.availability_zones, count.index )
#   map_public_ip_on_launch = true

#   tags = {
#     Name = "${lower(var.app_name)}-public-subnet-two"
#     Env  = var.env
#   }
# }

# # Private subnets one
# resource "aws_subnet" "private_subnet_one" {
#   vpc_id                  = aws_vpc.vpc.id
#   count                   = length(var.availability_zones)
#   cidr_block              = var.private_subnet_one
#   availability_zone       = element(var.availability_zones, count.index )

#   tags = {
#     Name = "${lower(var.app_name)}-private-subnet-one"
#     Env  = var.env
#   }
# }

# # Private subnets two
# resource "aws_subnet" "private_subnet_two" {
#   vpc_id                  = aws_vpc.vpc.id
#   count                   = length(var.availability_zones)
#   cidr_block              = var.private_subnet_two
#   availability_zone       = element(var.availability_zones, count.index )

#   tags = {
#     Name = "${lower(var.app_name)}-private-subnet-two"
#     Env  = var.env
#   }
# }


# # Public route table
# resource "aws_route_table" "public_route_table" {
#   vpc_id = aws_vpc.vpc.id
#   tags   = {
#     Name = "${lower(var.app_name)}public-route-table"
#     Env  = var.env
#   }
# }

# # Public route
# resource "aws_route" "public-route" {
#   route_table_id         = aws_route_table.public_route_table.id
#   destination_cidr_block = "0.0.0.0/0"
#   gateway_id             = aws_internet_gateway.igw.id
# }


# # Route table one association with public subnets
# resource "aws_route_table_association" "public-route-association-one" {
#   count          = length(var.public_subnet_one)
#   subnet_id      = element(aws_subnet.public_subnet_one.*.id, count.index)
#   # subnet_id      = aws_subnet.public_subnet_one.id
#   route_table_id = aws_route_table.public_route_table.id
# }

# # Route table two association with public subnets
# resource "aws_route_table_association" "public-route-association-two" {
#   count          = length(var.public_subnet_two)
#   subnet_id      = element(aws_subnet.public_subnet_two.*.id, count.index)
#   # subnet_id      = aws_subnet.public_subnet_two.id
#   route_table_id = aws_route_table.public_route_table.id
# }


# # Private route table one
# resource "aws_route_table" "private_route_table_one" {
#   vpc_id = aws_vpc.vpc.id
#   tags   = {
#     Name = "${lower(var.app_name)}private-route-table_one"
#     Env  = var.env
#   }
# }


# # Private route one
# resource "aws_route" "private_route_one" {
#   route_table_id          = aws_route_table.private_route_table_one.id
#   destination_cidr_block  = "0.0.0.0/0"
#   count                   = length(aws_nat_gateway.nat_gateway_one.*.id)
#   gateway_id              = element(aws_nat_gateway.nat_gateway_one.*.id, count.index)
# }


# # Route table one association with private subnets
# resource "aws_route_table_association" "private_route_association_one" {
#   count          = length(var.public_subnet_one)
#   subnet_id      = element(aws_subnet.public_subnet_one.*.id, count.index)
#   # subnet_id      = aws_subnet.private_subnet_one.id
#   route_table_id = aws_route_table.private_route_table_one.id
# }

# # Private route table two
# resource "aws_route_table" "private_route_table_two" {
#   vpc_id = aws_vpc.vpc.id
#   tags   = {
#     Name = "${lower(var.app_name)}private-route-table_two"
#     Env  = var.env
#   }
# }


# # Private route two
# resource "aws_route" "private_route_two" {
#   route_table_id         = aws_route_table.private_route_table_two.id
#   destination_cidr_block = "0.0.0.0/0"
#   count                   = length(aws_nat_gateway.nat_gateway_two.*.id)
#   gateway_id              = element(aws_nat_gateway.nat_gateway_two.*.id, count.index)
# }


# # Route table two association with private subnets
# resource "aws_route_table_association" "private_route_association_two" {
#   count          = length(var.public_subnet_two)
#   subnet_id      = element(aws_subnet.public_subnet_two.*.id, count.index)
#   # subnet_id      = aws_subnet.private_subnet_two.id
#   route_table_id = aws_route_table.private_route_table_two.id
# }

# # Nat gateway one
# resource "aws_nat_gateway" "nat_gateway_one" {
#   allocation_id = aws_eip.eip.id
#   count          = length(var.public_subnet_one)
#   subnet_id      = element(aws_subnet.public_subnet_one.*.id, count.index)
#   # subnet_id     = aws_subnet.public_subnet_one.id
#   depends_on    = [aws_internet_gateway.igw]
# }

# # Nat gateway two
# resource "aws_nat_gateway" "nat_gateway_two" {
#   allocation_id = aws_eip.eip.id
#   count          = length(var.public_subnet_two)
#   subnet_id      = element(aws_subnet.public_subnet_two.*.id, count.index)
#   # subnet_id     = aws_subnet.public_subnet_two.id
#   depends_on    = [aws_internet_gateway.igw]
# }

# # Elastic API for gateway
# resource "aws_eip" "eip" {
#   vpc = true
# }