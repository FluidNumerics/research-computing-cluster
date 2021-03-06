
module "rcc_tf" {
  source = "github.com/FluidNumerics/rcc-tf?ref=v3.1.1"
  cloudsql_enable_ipv4            = var.cloudsql_enable_ipv4
  cloudsql_slurmdb                = var.cloudsql_slurmdb
  cloudsql_name                   = var.cloudsql_name
  cloudsql_tier                   = var.cloudsql_tier
  cluster_name                    = var.cluster_name
  compute_node_scopes             = var.compute_node_scopes
  compute_node_service_account    = var.compute_node_service_account
  controller_machine_type         = var.controller_machine_type
  controller_disk_type            = var.controller_disk_type
  controller_image                = var.controller_image
  controller_instance_template    = var.controller_instance_template
  controller_disk_size_gb         = var.controller_disk_size_gb
  controller_labels               = var.controller_labels
  controller_secondary_disk       = var.controller_secondary_disk
  controller_secondary_disk_size  = var.controller_secondary_disk_size
  controller_secondary_disk_type  = var.controller_secondary_disk_type
  controller_scopes               = var.controller_scopes
  controller_service_account      = var.controller_service_account
  disable_login_public_ips        = var.disable_login_public_ips
  disable_controller_public_ips   = var.disable_controller_public_ips
  disable_compute_public_ips      = var.disable_compute_public_ips
  login_machine_type              = var.login_machine_type
  login_disk_type                 = var.login_disk_type
  login_image                     = var.login_image
  login_instance_template         = var.login_instance_template
  login_disk_size_gb              = var.login_disk_size_gb
  login_labels                    = var.login_labels
  login_network_storage           = var.login_network_storage
  login_node_scopes               = var.login_node_scopes
  login_node_service_account      = var.login_node_service_account
  login_node_count                = var.login_node_count
  network_name                    = var.network_name
  munge_key                       = var.munge_key
  jwt_key                         = var.jwt_key
  network_storage                 = var.network_storage
  partitions                      = var.partitions
  project                         = var.project
  shared_vpc_host_project         = var.shared_vpc_host_project
  subnetwork_name                 = var.subnetwork_name
  suspend_time                    = var.suspend_time
  zone                            = var.zone
  create_filestore                = var.create_filestore
  filestore                       = var.filestore 
  create_lustre                   = var.create_lustre
  lustre                          = var.lustre
}

resource "google_compute_firewall" "default" {
  name    = "pvserver"
  network = module.rcc_tf.network_name
  project = var.shared_vpc_host_project
  allow {
    protocol = "tcp"
    ports    = var.pvserver_ports
  }
  source_ranges = var.pvserver_source_ip_range
}
