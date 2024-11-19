### Create AWS network resources

# Create Amazon VPC
resource "aws_vpc" "vpc_01" {
  cidr_block       = format("%s.0.0/16", var.VPCCIDR)
  instance_tenancy = "default"

  tags = {
    Name         = format("%s-%s-%s", "vpc", var.Region, "01")
    resourcetype = "network"
    codeblock    = "network-3tier"
  }
}

# IAM role for VPC flow logging
resource "aws_iam_role" "vpclogging" {
  name = format("%s-%s-%s", "vpclogging-role", var.Region, "01")
  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect = "Allow",
        Principal = {
          Service = "vpc-flow-logs.amazonaws.com"
        },
        Action = "sts:AssumeRole"
      }
    ]
  })

  tags = {
    Name  = format("%s-%s-%s", "vpclogging-role", var.Region,"01")
    rtype = "security"
  }
}

resource "aws_iam_role_policy" "vpclogging" {
  name = format("%s-%s-%s", "vpclogging-access", var.Region, "01")
  role = aws_iam_role.vpclogging.id
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = [
          "logs:CreateLogStream",
          "logs:PutLogEvents",
          "logs:DescribeLogGroups",
          "logs:DescribeLogStreams",
        ]
        Effect   = "Allow"
        Resource = ["arn:aws:logs:*:*:*"]
      }
    ]
  })
}

# Create CloudWatch log group for VPC
resource "aws_cloudwatch_log_group" "vpc_01" {
  name              = format("%s/%s/%s", "vpcflowlogs", var.Region, "01")
  retention_in_days = 90
  #kms_key_id        = aws_kms_key.kms_key.arn

  tags = {
    Name         = format("%s/%s", "vpcflowlogs", var.Region)
    resourcetype = "monitor"
    codeblock    = "network"
  }
}

# Configure VPC flow logs
resource "aws_flow_log" "vpc_01" {
  iam_role_arn    = aws_iam_role.vpclogging.arn
  log_destination = aws_cloudwatch_log_group.vpc_01.arn
  traffic_type    = "ALL"
  vpc_id          = aws_vpc.vpc_01.id
}

# Create Internet Gateway
resource "aws_internet_gateway" "internet_gateway_01" {
  vpc_id = aws_vpc.vpc_01.id

  tags = {
    Name         = format("%s-%s-%s", "igw", "vpc", var.Region)
    resourcetype = "network"
    codeblock    = "network-3tier"

  }
}

# Create Subnets
resource "aws_subnet" "pub_subnet_01" {
  vpc_id            = aws_vpc.vpc_01.id
  cidr_block        = format("%s.1.0/24", var.VPCCIDR)
  availability_zone = var.AZ01

  tags = {
    Name         = format("%s-%s-%s-%s", "pub", "subnet-01", "vpc", var.Region)
    resourcetype = "network"
    codeblock    = "network-3tier"
  }
}

resource "aws_subnet" "pub_subnet_02" {
  vpc_id            = aws_vpc.vpc_01.id
  cidr_block        = format("%s.2.0/24", var.VPCCIDR)
  availability_zone = var.AZ02

  tags = {
    Name         = format("%s-%s-%s-%s", "pub", "subnet-02", "vpc", var.Region)
    resourcetype = "network"
    codeblock    = "network-3tier"
  }
}

resource "aws_subnet" "priv_subnet_01" {
  vpc_id            = aws_vpc.vpc_01.id
  cidr_block        = format("%s.3.0/24", var.VPCCIDR)
  availability_zone = var.AZ01

  tags = {
    Name         = format("%s-%s-%s-%s", "priv", "subnet-01", "vpc", var.Region)
    resourcetype = "network"
    codeblock    = "network-3tier"
  }
}

resource "aws_subnet" "priv_subnet_02" {
  vpc_id            = aws_vpc.vpc_01.id
  cidr_block        = format("%s.4.0/24", var.VPCCIDR)
  availability_zone = var.AZ02

  tags = {
    Name         = format("%s-%s-%s-%s", "priv", "subnet-02", "vpc", var.Region)
    resourcetype = "network"
    codeblock    = "network-3tier"
  }
}

# Create NAT Gateway
resource "aws_eip" "eip_nat_01" {
  depends_on = [aws_internet_gateway.internet_gateway_01]

  tags = {
    Name         = format("%s-%s-%s", "eip", "01", var.Region)
    resourcetype = "network"
    codeblock    = "network-3tier"
  }
}

resource "aws_eip" "eip_nat_02" {
  depends_on = [aws_internet_gateway.internet_gateway_01]

  tags = {
    Name         = format("%s-%s-%s", "eip", "02", var.Region)
    resourcetype = "network"
    codeblock    = "network-3tier"
  }
}

resource "aws_nat_gateway" "nat_gateway_01" {
  depends_on = [aws_internet_gateway.internet_gateway_01]

  allocation_id = aws_eip.eip_nat_01.id
  subnet_id     = aws_subnet.pub_subnet_01.id

  tags = {
    Name         = format("%s-%s-%s", "ngw", "01", var.Region)
    resourcetype = "network"
    codeblock    = "network-3tier"
  }
}

resource "aws_nat_gateway" "nat_gateway_02" {
  depends_on = [aws_internet_gateway.internet_gateway_01]

  allocation_id = aws_eip.eip_nat_02.id
  subnet_id     = aws_subnet.pub_subnet_02.id

  tags = {
    Name         = format("%s-%s-%s", "ngw", "02", var.Region)
    resourcetype = "network"
    codeblock    = "network-3tier"
  }
}

# Create Route Tables
resource "aws_route_table" "pub_01" {
  vpc_id = aws_vpc.vpc_01.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.internet_gateway_01.id
  }

  tags = {
    Name         = format("%s-%s-%s", "pub-route-table", "01", var.Region)
    resourcetype = "network"
    codeblock    = "network-3tier"
  }
}

resource "aws_route_table_association" "pub_01" {
  subnet_id      = aws_subnet.pub_subnet_01.id
  route_table_id = aws_route_table.pub_01.id
}

resource "aws_route_table_association" "pub_02" {
  subnet_id      = aws_subnet.pub_subnet_02.id
  route_table_id = aws_route_table.pub_01.id
}

resource "aws_route_table" "priv_01" {
  vpc_id = aws_vpc.vpc_01.id

  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.nat_gateway_01.id
  }

  tags = {
    Name         = format("%s-%s-%s", "priv-route-table", "01", var.Region)
    resourcetype = "network"
    codeblock    = "network-3tier"
  }
}

resource "aws_route_table" "priv_02" {
  vpc_id = aws_vpc.vpc_01.id

  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.nat_gateway_02.id
  }

  tags = {
    Name         = format("%s-%s-%s", "priv-route-table", "02", var.Region)
    resourcetype = "network"
    codeblock    = "network-3tier"
  }
}

resource "aws_route_table_association" "pv_01" {
  subnet_id      = aws_subnet.priv_subnet_01.id
  route_table_id = aws_route_table.priv_01.id
}

resource "aws_route_table_association" "pv_02" {
  subnet_id      = aws_subnet.priv_subnet_02.id
  route_table_id = aws_route_table.priv_02.id
}

# Create Security Groups
resource "aws_security_group" "web01" {
  name        = format("%s-%s-%s", "scg", "web01", var.Region)
  description = "Web Security Group"
  vpc_id      = aws_vpc.vpc_01.id

  ingress {
    description = "Web Inbound"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = [var.PublicIP]
  }

  egress {
    description = "Web Outbound"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name         = format("%s-%s-%s", "scg", "web01", var.Region)
    resourcetype = "security"
    codeblock    = "network-3tier"
  }
}

resource "aws_security_group" "app01" {
  name        = format("%s-%s-%s", "scg", "app01", var.Region)
  description = " Application Security Group"
  vpc_id      = aws_vpc.vpc_01.id

  ingress {
    description     = "Application Inbound"
    from_port       = 0
    to_port         = 0
    protocol        = "-1"
    security_groups = [aws_security_group.web01.id]
    self            = true
  }

  egress {
    description = "Application Outbound"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name         = format("%s-%s-%s", "scg", "app01", var.Region)
    resourcetype = "security"
    codeblock    = "network-3tier"
  }
}