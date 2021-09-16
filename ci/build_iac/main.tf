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

locals {
  tag_img_family = {for tag in var.tags : tag.name => tag.img_family}
  tag_prefix = {for tag in var.tags : tag.name => tag.prefix}
  tag_project = {for tag in var.tags : tag.name => tag.project}
  tag_description = {for tag in var.tags : tag.name => tag.description}
  tag_packer_json = {for tag in var.tags : tag.name => tag.packer_json}
  tag_disabled = {for tag in var.tags : tag.name => tag.disabled}
  tag_config = {for tag in var.tags : tag.name => tag.config}
}

resource "google_cloudbuild_trigger" "tagged_builds" {
  for_each = local.tag_img_family
  name = each.key
  project = local.tag_project[each.key]
  description = local.tag_description[each.key]
  disabled = local.tag_disabled[each.key]
  github {
    owner = "FluidNumerics"
    name = "research-computing-cluster"
    push {
      tag = local.tag_prefix[each.key]
    }
  }
  substitutions = {
    _ZONE = var.zone
    _SUBNETWORK = var.subnet
    _IMAGE_FAMILY = each.value
    _PACKER_JSON = local.tag_packer_json[each.key]
  }
  filename = local.tag_config[each.key]
}
