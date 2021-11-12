#################################
Manage Network Attached Storage
#################################

The RCC Cluster can integrate with Lustre and NFS file systems. You can add and remove network attached storage on-the-fly. This documentation will walk you through how to use the :code:`cluster-services` command line interface to manage network attached storage.


==============================
Recommended Storage Solutions
==============================

The RCC Cluster is capable of integrating with NFS and Lustre file systems. For NFS, `Google Cloud Filestore <https://cloud.google.com/filestore>`_ is the recommended solution.

If you anticipate a large number high throughput computing (HTC) workloads, or large parallel IO tasks, Lustre is ideal. To deploy a Lustre file system, you can use the open-source `Lustre-GCP <https://github.com/FluidNumerics/lustre-gcp_terraform>` repository to bake your own VM images and deploy a Lustre file system.



=====================================
Managing File systems with Terraform
=====================================

The RCC Terraform deployment module allows you to deploy a cluster with Filestore and/or Lustre. If you have not provisioned your cluster yet, or you are ok with re-deploying your current cluster, you can provision network attached storage resources upon deployment.

* `Read more on adding Filestore NFS with Terraform <https://research-computing-cluster.readthedocs.io/en/latest/QuickStart/deploy_with_terraform.html#add-filestore-nfs>`_

* `Read more on adding Lustre File System with Terraform <https://research-computing-cluster.readthedocs.io/en/latest/QuickStart/deploy_with_terraform.html#add-lustre-file-system>`_

==================================================
Mounting a new file system on an existing cluster
==================================================

Initialize cluster-services
============================
If this is your first time running the :code:`cluster-services` command on your RCC cluster, you need to first initialize this utility.


To initialize :code:`cluster-services`, 

1. Log on to your cluster's **controller** instance
2. Go root by running :code: `sudo su`
3. Run :code: `cluster-services init`. On Debian and Ubuntu RCC systems, you will need to reference the full path to :code:`cluster-services`, e.g. :code:`/apps/cls/bin/cluster-services init`

After initializing :code:`cluster-services`, you can log out of the controller.


Add a new mount
==================
The workflow for using cluster services is as follows :

1. Create a cluster configuration file
2. Edit the cluster configuration file
3. Preview changes to your system
4. Apply changes to your system

To use the cluster-services CLI, you will need to be a root user. For the steps given in this section, make sure that you are logged into your cluster's **login node**.

Create a cluster-configuration file
------------------------------------

To create a cluster configuration file, you will use the :code:`cluster-services list all` command.

.. code-block::shell

   $ sudo su
   $ cluster-services list all > config.yaml


On Debian and Ubuntu RCC systems, you will need to reference the full path to :code:`cluster-services`, e.g. :code:`/apps/cls/bin/cluster-services init`

Edit the cluster configuration file
-------------------------------------

Now that you have a cluster configuration file, you will edit the file to modify the :code:`network_storage`. The :code:`network_storage` dictionary key sets what file systems will be mounted to your login node and to compute nodes when they are created. Open :code:`config.yaml` in a text editor and search for the :code:`network_storage` key. Keep in mind that there is a cluster-wide :code:`network_storage` and a :code:`partitions.machines.network_storage` for each machine block; you want to work with the cluster-wide :code:`network_storage`.

Edit the :code:`network_storage` to set the following information 

* :code:`network_storage.fs_type` - The file system type. It can be set to one of :code:`nfs` or :code:`lustre`
* :code:`network_storge.local_mount` - The path on your cluster where you want the file system to mount.
* :code:`network_storge.mount_options` - The mount options for the file system. See `mount documentation <https://man7.org/linux/man-pages/man8/mount.8.html>`_ for more details. 
* :code:`network_storge.remote_mount` - The path on the remote file system that is exported for mounting.
* :code:`network_storge.server_ip` - The resolvable IP address or hostname for the file server. For Lustre, this is the IP address of the Lustre MDS server.

An example :code:`network_storage` definition is given below.
.. code-block::yaml

    network_storage:
    - fs_type: nfs
      local_mount: /mnt/nas
      mount_options: rw,hard,intr
      remote_mount: /mnt/nas
      server_ip: 10.1.0.12

Save your changes to :code:`config.yaml` and exit the text editor.

Preview changes to your system
--------------------------------

Before making changes to your system, we recommend previewing and reviewing the planned changes to your cluster. To update mounted file systems on your cluster, you will use the :code:`cluster-services update mounts` command and provide the modified cluster configuration file as the source for the update.

.. code-block::shell

   $ cluster-services update mounts --config=config.yaml --preview
     + network_storage[0] = {'fs_type': 'nfs', 'local_mount': '/mnt/nas', 'mount_options': 'rw,hard,intr', 'remote_mount': '/mnt/nas', 'server_ip': '10.1.0.12'}

Verify that the settings you have provided are as you intended before applying any changes.

Apply changes to your system
-------------------------------

Once you have confirmed the settings for your network storage, you can apply the changes.

.. code-block::shell

   $ cluster-services update mounts --config=config.yaml
     + network_storage[0] = {'fs_type': 'nfs', 'local_mount': '/mnt/nas', 'mount_options': 'rw,hard,intr', 'remote_mount': '/mnt/nas', 'server_ip': '10.1.0.12'}

To verify that the network storage has been mounted as expected, you can run :code:`df -h` to view all mounted file systems on your cluster's login node. Similarly, we recommend submitting a Slurm job step to verify the network storage mounts to your compute nodes as well.


.. code-block::shell

   $ srun -n1 df -h


