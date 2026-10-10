
terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }

  required_version = ">= 1.5.0"
}

provider "aws" {
  region = "ap-south-1"
}

resource "aws_s3_bucket" "cloudops_storage" {
  bucket = "cloudops-enterprise-storage-2026-1025"

  lifecycle {
    prevent_destroy = true
    ignore_changes  = [tags]
  }
}

resource "aws_s3_bucket_versioning" "cloudops_storage" {
  bucket = aws_s3_bucket.cloudops_storage.id

  versioning_configuration {
    status = "Enabled"
  }
}

resource "aws_s3_bucket_lifecycle_configuration" "cloudops_storage" {
  bucket = aws_s3_bucket.cloudops_storage.id

  rule {
    id     = "CloudOps-Archive-Rule"
    status = "Enabled"

    filter {
      prefix = "archive/"
    }

    transition {
      days          = 30
      storage_class = "GLACIER"
    }
  }
}

resource "aws_s3_bucket_public_access_block" "cloudops_storage" {
  bucket = aws_s3_bucket.cloudops_storage.id

  block_public_acls       = true
  ignore_public_acls      = true
  block_public_policy     = true
  restrict_public_buckets = true
}

resource "aws_vpc" "cloudops" {
  cidr_block = "10.0.0.0/16"

  tags = {
    Name = "CloudOps-VPC"
  }

  lifecycle {
    prevent_destroy = true
  }
}



resource "aws_subnet" "public_a" {
  vpc_id                  = aws_vpc.cloudops.id
  cidr_block              = "10.0.1.0/24"
  availability_zone       = "ap-south-1a"
  map_public_ip_on_launch = true

  tags = {
    Name = "Public-Subnet-A"
  }

  lifecycle {
    prevent_destroy = true
  }
}

resource "aws_subnet" "private_app_a" {
  vpc_id                  = aws_vpc.cloudops.id
  cidr_block              = "10.0.2.0/24"
  availability_zone       = "ap-south-1a"
  map_public_ip_on_launch = false

  tags = {
    Name = "Private-App-Subnet-A"
  }

  lifecycle {
    prevent_destroy = true
  }
}

resource "aws_subnet" "private_db_a" {
  vpc_id                  = aws_vpc.cloudops.id
  cidr_block              = "10.0.3.0/24"
  availability_zone       = "ap-south-1b"
  map_public_ip_on_launch = false

  tags = {
    Name = "Private-DB-Subnet-A"
  }

  lifecycle {
    prevent_destroy = true
  }
}

resource "aws_subnet" "public_b" {
  vpc_id                  = aws_vpc.cloudops.id
  cidr_block              = "10.0.4.0/24"
  availability_zone       = "ap-south-1b"
  map_public_ip_on_launch = true

  tags = {
    Name = "Public-Subnet-B"
  }

  lifecycle {
    prevent_destroy = true
  }
}


resource "aws_internet_gateway" "cloudops" {
  vpc_id = aws_vpc.cloudops.id

  tags = {
    Name = "CloudOps-IGW"
  }

  lifecycle {
    prevent_destroy = true
  }
}


resource "aws_route_table" "public" {
  vpc_id = aws_vpc.cloudops.id

  tags = {
    Name = "CloudOps-Public-RT"
  }

  lifecycle {
    prevent_destroy = true
  }
}

resource "aws_route_table" "private" {
  vpc_id = aws_vpc.cloudops.id

  tags = {
    Name = "CloudOps-Private-RT"
  }

  lifecycle {
    prevent_destroy = true
  }
}

resource "aws_route_table" "database" {
  vpc_id = aws_vpc.cloudops.id

  tags = {
    Name = "CloudOps-DB-RT"
  }

  lifecycle {
    prevent_destroy = true
  }
}

resource "aws_default_route_table" "main" {
  default_route_table_id = "rtb-029e1982a42925eee"

  lifecycle {
    prevent_destroy = true
  }
}
