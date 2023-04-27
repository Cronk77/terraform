# VPC, Subnets, and Security Group##################
resource "aws_vpc" "db" {
  cidr_block           = var.db_cidr
	# needed for the interface endpoint
  enable_dns_support   = true
  enable_dns_hostnames = true
  tags                 = {
    Name = "CC-RDS-VPC"
  }
}

# query the AZs
data "aws_availability_zones" "available" {
  state = "available"
}

# create 2 subnets
resource "aws_subnet" "db" {
  count             = 2
  vpc_id            = aws_vpc.db.id
  cidr_block        = cidrsubnet(aws_vpc.db.cidr_block, 8, count.index)
  availability_zone = data.aws_availability_zones.available.names[count.index]
}

resource "aws_internet_gateway" "db-igw" {
  vpc_id = aws_vpc.db.id
  tags   = {
    Name = "cc-db-igw"
  }
}

resource "aws_route_table" "db_route_table" {
  vpc_id = aws_vpc.db.id
  tags   = {
    Name = "cc-db-route-table"
  }
}


resource "aws_route" "public-route" {
  route_table_id         = aws_route_table.db_route_table.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.db-igw.id
}

# Route table association with public subnets
resource "aws_route_table_association" "db-route-association" {
  count          = 2
  subnet_id      = element(aws_subnet.db.*.id, count.index )
  route_table_id = aws_route_table.db_route_table.id
}

# allow data flow between the components
resource "aws_security_group" "db" {
  vpc_id = aws_vpc.db.id

  ingress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = [aws_vpc.db.cidr_block, "0.0.0.0/0"]
    # cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = [aws_vpc.db.cidr_block, "0.0.0.0/0"]
    # cidr_blocks = ["0.0.0.0/0"]
  }
}

# RDS Cluster#####################################
# initial password
resource "random_password" "db_master_pass" {
  length           = 40
  special          = true
  min_special      = 5
  override_special = "!#$%^&*()-_=+[]{}<>:?"
}

# random unique id
resource "random_id" "id" {
  byte_length = 8
}

# the secret
resource "aws_secretsmanager_secret" "db-pass" {
  name = "cc-db-pass-${random_id.id.hex}"
  recovery_window_in_days = 0
}


# add the cluster to the 2 subnets
resource "aws_db_subnet_group" "db" {
  subnet_ids = aws_subnet.db[*].id
}

# RDS instance
resource "aws_db_instance" "rds" {
  identifier             = "${var.app_name}-database"
  allocated_storage      = var.allocated_storage
  engine                 = "mysql"
  engine_version         = var.engine_version
  availability_zone      = var.availability_zones[0]
  instance_class         = var.db_instance_class
  name                   = var.db_name
  username               = var.db_user_name
  password               = random_password.db_master_pass.result
  db_subnet_group_name   = aws_db_subnet_group.db.name
  vpc_security_group_ids = ["${aws_security_group.db.id}"]
  skip_final_snapshot    = true
  publicly_accessible    = true
}


# initial version
resource "aws_secretsmanager_secret_version" "db-pass-val" {
  secret_id = aws_secretsmanager_secret.db-pass.id
	# encode in the required format
  secret_string = jsonencode(
    {
      username = aws_db_instance.rds.username
      password = aws_db_instance.rds.password
      engine   = "mysql"
      host     = aws_db_instance.rds.endpoint # aws_db_instance.rds.address
    }
  )
}

# Secrets Manager Endpoint#####################
# Allows for connection to Secret Manager
resource "aws_vpc_endpoint" "secretsmanager" {
  vpc_id              = aws_vpc.db.id
  service_name        = "com.amazonaws.${data.aws_region.current.name}.secretsmanager"
  vpc_endpoint_type   = "Interface"
  private_dns_enabled = true
	# deploy in the first subnet
  subnet_ids          = [aws_subnet.db[0].id]
	# attach the security group
  security_group_ids  = [aws_security_group.db.id]
}

# # Rotator stack#################################
# # find the details by id of lambda application
# data "aws_serverlessapplicationrepository_application" "rotator" {
#   application_id = "arn:aws:serverlessrepo:us-east-1:297356227824:applications/SecretsManagerRDSMySQLRotationSingleUser"
# }

# data "aws_partition" "current" {}
data "aws_region" "current" {}

# # Deploy the cloudformation stack via lambda
# resource "aws_serverlessapplicationrepository_cloudformation_stack" "rotate-stack" {
#   name             = "Rotate-${random_id.id.hex}"
#   application_id   = data.aws_serverlessapplicationrepository_application.rotator.application_id
#   semantic_version = data.aws_serverlessapplicationrepository_application.rotator.semantic_version
#   capabilities     = data.aws_serverlessapplicationrepository_application.rotator.required_capabilities

#   parameters = {
# 		# secrets manager endpoint
#     endpoint            = "https://secretsmanager.${data.aws_region.current.name}.${data.aws_partition.current.dns_suffix}"
# 		# a random name for the function
#     functionName        = "rotator-${random_id.id.hex}"
# 		# deploy in the first subnet
#     vpcSubnetIds        = aws_subnet.db[0].id
# 		# attach the security group so it can communicate with the other componets
#     vpcSecurityGroupIds = aws_security_group.db.id
#   }
# }

# # Rotation#######################################
# resource "aws_secretsmanager_secret_rotation" "rotation" {
# 	# secret_id through the secret_version so that it is deployed before setting up rotation
#   secret_id           = aws_secretsmanager_secret_version.db-pass-val.secret_id
#   rotation_lambda_arn = aws_serverlessapplicationrepository_cloudformation_stack.rotate-stack.outputs.RotationLambdaARN

#   rotation_rules {
#     automatically_after_days = 14
#   }
# }

##################################################
#These next two functions are used to be able to grab the DB credentials for other terraform files

#Getting secret values for outputs to be consumed
data "aws_secretsmanager_secret" "rds_secret" {
  arn = "${aws_secretsmanager_secret.db-pass.arn}"
}

data "aws_secretsmanager_secret_version" "rds_secret_ver" {
  depends_on = [aws_secretsmanager_secret_version.db-pass-val]
  secret_id = data.aws_secretsmanager_secret.rds_secret.id
}

locals {
  db_creds = jsondecode(data.aws_secretsmanager_secret_version.rds_secret_ver.secret_string)
}
