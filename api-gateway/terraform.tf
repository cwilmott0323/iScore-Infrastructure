data "terraform_remote_state" "lambda" {
  backend = "s3"
  config = {
    bucket  = "iscore-terraform-state"
    key = "terraform-lambda/terraform.tfstate"
    region  = "us-east-2"
  }
}

terraform {
  backend "s3" {
    // This bucket is configured by terraform-iam.
    bucket = "iscore-terraform-state"
    key    = "terraform-api-gateway/terraform.tfstate"
    region = "us-east-2"
  }
}