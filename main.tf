terraform {
    required_providers {
        aws = {
            source = "hashicorp/aws"
        }
    }
}

provider "aws" {
    access_key = "test"
    secret_key = "test"
    region = "us-west-1"
    skip_credentials_validation = true
    skip_metadata_api_check = true
    skip_requesting_account_id = true
    endpoints {
        s3             = "http://localhost:4566"
        lambda         = "http://localhost:4566"
    }
}

module "create_lambda" {
  depends_on = [module.scripts_bucket]
  source = "./modules/lambda"
  lambda_name = "test_lambda"
}

module "scripts_bucket" {
  source = "./modules/s3"
  bucket_name = "codz-bucket"
}

module "data_bucket" {
  source = "./modules/s3"
  bucket_name = "dataz-bucket"
}