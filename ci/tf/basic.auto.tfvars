cluster_name = "<image>"
project      = "fluid-cluster-ops"
zone         = "us-central1-a"
controller_machine_type = "n1-standard-2"
controller_image        = "projects/fluid-cluster-ops/global/images/<image>"
controller_disk_type    = "pd-standard"
controller_disk_size_gb = 50
login_machine_type = "n1-standard-2"
login_image        = "projects/fluid-cluster-ops/global/images/<image>"
login_disk_type    = "pd-standard"
login_disk_size_gb = 50
partitions = [
  { name                 = "debug"
    machine_type         = "c2-standard-4"
    static_node_count    = 0
    max_node_count       = 10
    zone                 = "us-central1-a"
    image                = "projects/fluid-cluster-ops/global/images/<image>"
    image_hyperthreads   = true
    compute_disk_type    = "pd-standard"
    compute_disk_size_gb = 50
    compute_labels       = {}
    cpu_platform         = null
    gpu_count            = 0
    gpu_type             = null
    network_storage      = []
    preemptible_bursting = false
    vpc_subnet           = null
    exclusive            = false
    enable_placement     = false
    regional_capacity    = false
    regional_policy      = {}
    instance_template    = null
  },
]

