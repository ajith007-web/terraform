provider "aws" {
  region = "ap-south-1"
}


resource "tls_private_key" "RSA_example" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

resource "aws_key_pair" "RSA_example" {
  key_name   = "terraform-key"
  public_key = tls_private_key.RSA_example.public_key_openssh
}

resource "local_file" "private_key" {
  content  = tls_private_key.RSA_example.private_key_pem
  filename = "${path.module}/private_key.pem"
}

resource "aws_instance" "RSA_example" {
  ami           = var.ec2_ami
  instance_type = var.instance_type
  key_name      = aws_key_pair.RSA_example.key_name
  tags = {
    Name = var.instance_name
  }
}


resource "aws_s3_bucket" "terraform_bucket" {
  bucket_prefix = "terraform-bucket"
  lifecycle {
    # Terraform will throw an error and halt if anyone tries to destroy this
    prevent_destroy = true 
  }
}

resource "aws_s3_bucket_versioning" "s3_bucket_versioning" {
  bucket = aws_s3_bucket.terraform_bucket.id

  versioning_configuration {
    status = "Enabled"
  }
}
resource "aws_s3_bucket_server_side_encryption_configuration" "s3_bucket_encryption" {
  
  bucket = aws_s3_bucket.terraform_bucket.id

  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
  }
}

resource "aws_s3_bucket_public_access_block" "s3_bucket_public_access_block" {
  
  bucket = aws_s3_bucket.terraform_bucket.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}