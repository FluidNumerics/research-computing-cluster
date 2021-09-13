terraform {
  backend "gcs" {
    bucket  = "research-computing-cloud_cloudbuild"
    prefix  = "rcc-cluster-ci"
  }
}

provider "google" {
}

locals {
  bld_img_family = {for bld in var.builds : bld.name => bld.img_family}
  bld_branch = {for bld in var.builds : bld.name => bld.branch}
  bld_project = {for bld in var.builds : bld.name => bld.project}
  bld_description = {for bld in var.builds : bld.name => bld.description}
  bld_packer_json = {for bld in var.builds : bld.name => bld.packer_json}
  bld_disabled = {for bld in var.builds : bld.name => bld.disabled}
}

resource "google_cloudbuild_trigger" "rcc_cluster" {
  for_each = local.bld_img_family
  name = each.key
  project = local.bld_project[each.key]
  description = local.bld_description[each.key]
  disabled = local.bld_disabled[each.key]
  github {
    owner = "FluidNumerics"
    name = "research-computing-cluster"
    push {
      branch = local.bld_branch[each.key]
    }
  }
  substitutions = {
    _ZONE = var.zone
    _SUBNETWORK = var.subnet
    _IMAGE_FAMILY = each.value
    _PACKER_JSON = local.bld_packer_json[each.key]
  }
  filename = "ci/cloudbuild.yaml"
}
