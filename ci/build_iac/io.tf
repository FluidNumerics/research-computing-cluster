

variable "builds" {
  type = list(object({
    name = string
    branch = string
    img_family = string
    project = string
    description = string
    packer_json = string
    disabled = bool
  }))
  description = "List of branch build triggers"
}

variable "tags" {
  type = list(object({
    name = string
    prefix = string
    img_family = string
    project = string
    description = string
    packer_json = string
    disabled = bool
    config = string
    rcc_file = string
  }))
  description = "List of tagged build triggers"
}

variable "zone" {
  type = string
  description = "GCP Zone to deploy your cluster cluster. Learn more at https://cloud.google.com/compute/docs/regions-zones"
}

variable "subnet" {
  type = string
  description = "Subnetwork to deploy image nodes and test clusters to."
  default = "default"
}
