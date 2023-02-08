terraform {
  backend "s3" {
    // This bucket is configured by terraform-iam.
    bucket = "iscore-terraform-state-manager"
    key    = "terraform-backend/terraform.tfstate"
    region = "us-east-2"
  }
}

data "terraform_remote_state" "network" {
  backend = "s3"
  config = {
    bucket = "iscore-terraform-state-manager"
    key    = "terraform-network/terraform.tfstate"
    region = "us-east-2"
  }
}


