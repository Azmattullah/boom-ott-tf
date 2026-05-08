terraform {
  backend "gcs" {
    bucket = "boom-ott-tf-state-bucket"
    prefix = "terraform/state"
  }
}
