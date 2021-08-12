terraform {
  backend "gcs" {
    bucket  = "research-computing-cloud_cloudbuild"
    prefix  = "rcc-cluster-ci"
  }
}

provider "google" {
}

locals {
  region = trimsuffix(var.zone,substr(var.zone,-2,-2))
}

resource "google_cloudbuild_trigger" "fluid-slurm-gcp" {
  count = length(var.builds)
  name = ""
  project = var.project
  description = "Resarch computing cluster (${var.builds[count.index].branch})"
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
    _SOURCE_IMAGE_FAMILY = var.builds[count.index].source_img_family
    _SOURCE_IMAGE_PROJECT = var.builds[count.index].source_img_project
    _PACKER_JSON = var.builds[count.index].packer_json
  }
  filename = "ci/cloudbuild.yaml"
}
