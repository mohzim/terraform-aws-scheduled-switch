terraform {
   backend "s3" {
    bucket = "mohzim-terraform"
    key    = "terraform-aws-scheduled-switch-parent-tfstate"
    region = "ap-south-1"
  }

  required_version = ">= 1.1.0"

  required_providers {
    aws = {
      version = ">= 3.0"
    }

    random = {
      version = ">= 3.0"
    }
  }
}