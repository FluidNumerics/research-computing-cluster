######################################
Deploy with Terraform
######################################

The Research Computing Cluster (RCC) can be deployed with Terraform infrastructure as code or using :doc:`the Google Cloud Marketplace or by using <./deploy_from_marketplace>`. Three different operating systems are available for the RCC and all are available on the Google Cloud Marketplace : 

* `CentOS 7 <https://console.cloud.google.com/marketplace/fluid-cluster-ops/rcc-centos>`_
* `Debian 10 <https://console.cloud.google.com/marketplace/fluid-cluster-ops/rcc-debian>`_
* `Ubuntu 20.04 <https://console.cloud.google.com/marketplace/fluid-cluster-ops/rcc-ubuntu>`_

All of the solutions have the same configurations available when deploying with Terraform. This guide will walk you through configuring a RCC deployment using the `rcc-tf <https://github.com/FluidNumerics/rcc-tf>`_ module by deploying `examples on the Research Computing Cluster repository <https://github.com/FluidNumerics/research-computing-cluster/tree/main/tf>`_.


==============
Tutorial
==============

Getting Started
================
First, decide which RCC solution you want to deploy (CentOS, Debian, or Ubuntu). This typically depends on operating system preference. 

Be aware of the following limitations :

* Ubuntu and Debian clusters do not have Lustre client installed. If you plan on using a Lustre file system, you will need to use the CentOS solution.
* The Debian cluster does not support ROCm, since AMD only support ROCm on Ubuntu and CentOS clusters.

To learn about pricing and licensing and features of the RCC solutions, you can start by heading to one of the following marketplace pages for the RCC 

* `RCC-CentOS (CentOS 7) <https://console.cloud.google.com/marketplace/fluid-cluster-ops/rcc-centos>`_
* `RCC-Debian (Debian 10) <https://console.cloud.google.com/marketplace/fluid-cluster-ops/rcc-debian>`_
* `RCC-Ubuntu (Ubuntu 20.04) <https://console.cloud.google.com/marketplace/fluid-cluster-ops/rcc-ubuntu>`_

We recommend that you `log into Google Cloud Shell <https://shell.cloud.google.com?show=terminal>`_, since Cloud Shell provides necessary authentication and command line tools, including Terraform, git, and the gcloud SDK. If you plan to use your own system, you will need to `install and initialize the gcloud SDK <https://cloud.google.com/sdk/docs/install>`_ and `Terraform <https://terraform.io>`_.

Next, clone the research-computing-cluster repository

.. code-blck:: shell

    git clone https://github.com/FluidNumerics/research-computing-cluster ~/research-computing-cluster/
    cd ~/research-computing-cluster

The research-computing-cluster repository provides example deployments for each supported operating system under the :code:`tf/` subdirectory.

Create the terraform plan
=================================
Once you have chosen which operating system you want to use, navigate to the appropriate directory under :code:`tf`, e.g. : 

.. code-block:: shell

    cd ~/research-computing-cluster/tf/rcc-centos

Each example comes with a Makefile system that allows you to customize your deployment and to create a :code:`tfvars` file to help you get started quickly. 

Set the following environment variables

* :code:`RCC_NAME` - The name of your cluster. This name is used to prefix the names of resources in your cluster. For example, if :code:`RCC_NAME="rcc"`, your controller and login node will be named :code:`rcc-controller` and :code:`rcc-login-1` respectively.
* :code:`RCC_PROJECT` - This is the your Google Cloud project ID. You can obtain your project ID by running :code:`gcloud config get-value project`.
* :code:`RCC_ZONE` - The `Google Cloud zone <https://cloud.google.com/compute/docs/regions-zones>`_ where you want to deploy your cluster. Keep in mind that compute partitions can be placed in multiple zones during or after deployment; this will be covered in the next section of this tutorial.
* :code:`RCC_MACHINE_TYPE` - The machine type to use for your first compute partition. In the next section of this tutorial, we'll cover how to add more partitions before deployment.
* :code:`RCC_MAX_NODE` - The maximum number of nodes to support in the first compute partition.

In the example below, we've configured a cluster named :code:`rcc` to be deployed in :code:`us-west1-b` with 10x :code:`c2-standard-8` compute nodes in the first partition.

.. code-block:: shell

    export RCC_NAME="rcc"
    export RCC_PROJECT="YOUR_GOOGLE_PROJECT_ID"
    export RCC_ZONE="us-west1-b"
    export RCC_MACHINE_TYPE="c2-standard-8"
    export RCC_MAX_NODE=10

Once you've set the environment variables, you can create the :code:`basic.tfvars` file and generate a terraform plan.

.. code-block:: shell

    make plan

In addition to creating the :code:`basic.tfvars` file, this step creates :code:`terraform.tfplan` which lists the resources that will be created when you are ready.

(Optional) Customize your deployment
=====================================
The basic plan that is created in the previous step creates a cluster with the following configuration

* Controller - :code:`n1-standard-4` machine with 250 GB PD-Standard disk
* Login - :code:`n1-standard-4` machine with 100 GB PD-Standard disk
* Compute - Single compute partition (no GPUs) using the machine type and maximum node count requested.

If this is sufficient for your needs, you can move onto the next step. If you need to customize the deployment, open :code:`basic.tfvars` in a text editor and customize the deployment values to suit your needs.

Cutomize Partitions
---------------
You can modify the :code:`partitions` object in :code:`basic.tfvars` to add multiple parititons, configure multi-region deployments, or add GPUs to compute nodes. We recommend duplicating the first partition as a template (lines 40-62 of :code:`basic.tfvars`) to give you a good starting point to adding other partitions.

Add Filestore NFS
------------------
The rcc-tf module comes with an easy to use configuration to create and attach a Filestore instance to your cluster. To add a Filestore instance to your cluster, set :code:`create_filestore = true` and configure the :code:`filestore` object to meet your needs.

.. code-block:: shell

    create_filestore = true
    filestore = { name = "filestore"
                  zone = null
                  tier = "PREMIUM"
                  capacity_gb = 2048
                  fs_name = "nfs"
                  network = null
                }

The example above creates a premium tier filestore instance with 2 TB capacity. Setting :code:`zone=null` and :code:`network=null` allows the rcc-tf module to set the zone and network to match those used for your controller and login node instances.

The mount point for Filestore on your cluster is automatically set to :code:`/mnt/filestore`.

Add Lustre File System
-----------------------
The rcc-tf module comes with an easy to use configuration to create and attach a Lustre file system to your cluster. To add a Filestore instance to your cluster, set :code:`create_lustre = true` and configure the :code:`lustre` object to meet your needs.

We recommend that you use the provided settings for Lustre and increase the :code:`oss_node_count` to increase file system capacity and performance.
