#######################
RCC Architecture
#######################

==========
Overview
==========

uThe Research Computing Cloud (RCC) Slurm Cluster is designed to replicate traditional on-premise HPC resources. It consists of a Slurm controller node, login nodes, compute nodes, and networking resources. Optionally, you can add NFS and Lustre file systems to the cluster to increase your storage capacity and file IO performance. 

========================
Architecture Components
========================

Controller
===========
The Controller instance hosts the Slurm controller daemon and, by default, the Slurm database and database daemon, and :code:`/home`, :code:`/apps`, :code:`/etc/munge`, and :code:`/usr/local/slurm` directories over NFS. In addition to hosting these resources, the controller is responsible for creating and deleting compute nodes to match workload demands.

Login
=======
Login nodes are the primary access point to the cluster for developers and researchers ("users"). Since the login nodes are shared resources amongst users, the login nodes are intended to be used for lightweight activities, including text editing, code compiling, and job submission. Large data transfers, software builds, and compute intensive workloads should be scheduled to run on compute nodes.

For Continuous Integration / Continuous Benchmarking (CI/CB) deployments, login nodes are typically not needed. See `Fluid-Run Documentation <https://fluid-run.readthedocs.io>`_ for more details.

Compute
=========
Compute nodes are used to execute scheduled workloads. Compute nodes are defined by specifying **compute partitions** that consists of groups of **machine blocks**. Each machine block is a homogeneous group of Google Compute Engine instances defined by the following attributes

* :code:`name` - The prefix for all instances in this machine block.
* :code:`machine_type` - `Google Compute Engine machine type <https://cloud.google.com/compute/docs/machine-types>`_
* :code:`max_node_count` - The number of compute instances in this machine block
* :code:`zone` - The `Google Cloud zone <https://cloud.google.com/compute/docs/regions-zones>`_ to deploy machines to in this machine block. If :code:`regional_capacity=True`, instances are deployed to any zone within the corresponding region.
* :code:`image` - The VM image to use for machines in this block. By default, this is set to the image used by the controller and login nodes. Using custom images is often used to deploy specific applications to the cluster. See `RCC-Apps <https://github.com/fluidnumerics/rcc-apps>`_ for details on creating and deploying custom VM images to the RCC.
* :code:`image_hyperthreads` - Boolean flag to indicate if hyperthreading is enabled (:code:`True`) or not (:code:`False`).
* :code:`compute_disk_type` - The `boot disk type <https://cloud.google.com/compute/docs/disks>`_.
* :code:`compute_disk_size_gb` - The size of the boot disk in GB.
* :code:`compute_labels` - Any `labels <https://cloud.google.com/resource-manager/docs/creating-managing-labels>`_ to apply to compute nodes when deployed.
* :code:`cpu_platform` - The minimum `CPU platform <https://cloud.google.com/compute/docs/cpu-platforms>`_ to request for compute nodes.
* :code:`gpu_type` - The `type of GPU <https://cloud.google.com/compute/docs/gpus>`_ to attach to compute nodes. `GPUs are only available in select zones <https://cloud.google.com/compute/docs/gpus/gpu-regions-zones>`_.
* :code:`gpu_count` - The number of GPUs to attach to each instance.
* :code:`gvnic` - Boolean to enable (:code:`True`) or disable (:code:`False`) `Google Virtual NIC <https://cloud.google.com/compute/docs/networking/using-gvnic>`_. GVNIC is used to increase peak network bandwidth.
* :code:`preemptible_bursting` - Boolean to enable `preemptible instances <https://cloud.google.com/compute/docs/instances/preemptible>`_. Jobs should be capable of recovering of preemption. The RCC comes with `Distributed Multithreaded Checkpointing (DMTCP) <https://docs.nersc.gov/development/checkpoint-restart/dmtcp/`>_ to support application recovery (even for MPI applications)
* :code:`vpc_subnet` - The VPC subnetwork to deploy compute nodes to. If not specified, the subnetwork used to host the controller and login nodes is used.
* :code:`exclusive` - Boolean to set job scheduling to exclusive (one job per node, :code:`True`).
* :code:`enable_placement` - Boolean to enable `placement policy <https://cloud.google.com/compute/docs/instances/define-instance-placement>`_ for compute node scheduling.
* :code:`regional_capacity` - Boolean to enable a `spread placement policy <https://cloud.google.com/compute/docs/instances/define-instance-placement#compact>`_. When set to `False`, a `compace placement policy <https://cloud.google.com/compute/docs/instances/define-instance-placement#compact` is used. :code:`enable_placement` must also be set to true.
* :code:`regional_policy` - A previously created regional placement policy.
* :code:`static_node_count`  - The number of static nodes in this machine block. 
