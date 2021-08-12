

variable "builds" {
  type = list(object({
    branch = string
    img_family = string
  }))
  description = "List of branch build triggers"
}

variable "project" {
  type = string
  description = "GCP Project ID"
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
