terraform {
  backend "s3" {
    bucket       = "mirsys-tf-state-bucket"
    key          = "prod/terraform.tfstate"
    region       = "us-east-2"
    use_lockfile = true
    encrypt      = true
  }
}