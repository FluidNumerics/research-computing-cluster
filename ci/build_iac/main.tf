terraform {
  backend "gcs" {
    bucket  = "research-computing-cloud_cloudbuild"
    prefix  = "rcc-cluster-ci"
  }
}

provider "google" {
}

resource "google_cloudbuild_trigger" "rcc_cluster" {
  count = length(var.builds)
  name = ""
  project = var.builds[count.index].project
  description = var.builds[count.index].description
  github {
    owner = "FluidNumerics"
    name = "research-computing-cluster"
    push {
      branch = var.builds[count.index].branch
    }
  }
  substitutions = {
    _ZONE = var.zone
    _SUBNETWORK = var.subnet
    _IMAGE_FAMILY = var.builds[count.index].img_family
    _PACKER_JSON = var.builds[count.index].packer_json
  }
  filename = "ci/cloudbuild.yaml"
}
