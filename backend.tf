terraform {
  backend "s3" {
    bucket = "terraformstate4891"
    key    = "terraform/backend"
    region = "us-east-1"
  }
}
