terraform {
  # backend "s3" {
  #   bucket      = "bucket-terraform-state"
  #   key         = "terraform.tfstate"
  #   region      = "ap-southeast-4"
  #   endpoint    = "https://obs.ap-southeast-4.myhuaweicloud.com"
  #   access_key  = ""
  #   secret_key  = ""
    
  #   # bypass AWS-specific checks
  #   skip_region_validation      = true
  #   skip_credentials_validation = true
  #   skip_metadata_api_check     = true
  #   skip_requesting_account_id  = true
  #   skip_s3_checksum            = true
  # }

  backend "local" {
    path = "backends/terraform.tfstate"
  }
}

# Provider Huawei Cloud
provider "huaweicloud" {
  region     = var.region
  access_key = var.access_key
  secret_key = var.secret_key
}

