#export GOOGLE_APPLICATION_CREDENTIALS={{path}}

provider "google" {
  project = "artifact-flow"
  region  = "us-west1"
  zone    = "us-west1-c"
}

terraform {
  backend "gcs" {
    bucket = "si-assessment-ie3-platform-tfstate"
    prefix = "terraform/state"
  }
}
