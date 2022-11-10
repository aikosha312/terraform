terraform {
  backend "s3" {
    profile = "default"
    region  = "us-east-1"
    bucket  = "rustemtentech"
    key     = "hw1_state_file"
  }
}
Footer
