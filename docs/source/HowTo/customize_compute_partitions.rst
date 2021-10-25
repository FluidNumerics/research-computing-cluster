################################
Customize Compute Partitions
################################

==========
Overview
==========
When operating an auto-scaling HPC cluster on the cloud, you have access to all of the various arrangements of virtual machines that the cloud provider has to offer. On Google Cloud, you can choose 

* CPU platform/machine type (n1, n2, n2d, c2, e2)
* Number of vCPU/VM
* Amount of memory/VM
* GPU Type and GPU Count/per VM
* Preemptibility
* VM image
* Placement Policies
* Network features

This gives you numerous options when customizing a heterogeneous Cloud-HPC cluster for your organization. To facilitate customization of your cluster's compute nodes at any time, RCC comes with a command line tool called cluster-services and a dictionary schema to describe your cluster called a cluster-config.

============================================
Understanding Partitions and Machine Blocks
============================================

Machine Blocks
===============
A machine block is a homogeneous group of Google Compute Engine (GCE) instances. VMs in a machine block share the following attributes

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

Partitions
===========
Partitions (synonymous with Slurm Partitions) consist of an array of machine-blocks that have a few shared attributes : 

* :code:`project` - A Google Cloud Project is used to group and manage cloud resources, billing, and permissions. You can configure multiple partitions in your cluster, each with their own GCP project. This provides an easy method for dividing up your monthly cloud bills across multiple cost-centers. 

* :code:`max_time` - The maximum time, or wall clock limit, for jobs submitted to this partition.

 On RCC clusters, you are able to have multiple compute partitions, with each partition having multiple machine types. This level of composability allows you to meet various business and technical needs.

===========
Examples
===========

Add a new partition
====================

.. code-block:: shell

    $ sudo su
    $ cluster-services init
    $ cluster-services list all > config.yaml

Edit :code:`config.yaml`
