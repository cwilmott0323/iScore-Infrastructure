terraform {
  backend "s3" {
    // This bucket is configured by terraform-iam.
    bucket = "iscore-terraform-state-manager"
    key    = "terraform-frontend/terraform.tfstate"
    region = "us-east-2"
  }
}