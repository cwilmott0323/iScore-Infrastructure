data "terraform_remote_state" "api-gateway" {
  backend = "s3"
  config = {
    bucket  = "iscore-terraform-state"
    key = "terraform-api-gateway/terraform.tfstate"
    region  = "us-east-2"
  }
}

data "terraform_remote_state" "network" {
  backend = "s3"
  config = {
    bucket  = "iscore-terraform-state"
    key = "terraform-network/terraform.tfstate"
    region  = "us-east-2"
  }
}

terraform {
  backend "s3" {
    // This bucket is configured by terraform-iam.
    bucket = "iscore-terraform-state"
    key    = "terraform-lambda/terraform.tfstate"
    region = "us-east-2"
  }
}


