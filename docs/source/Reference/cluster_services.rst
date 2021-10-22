##################
Cluster Services
##################

==========
Overview
==========
Operating HPC clusters in Google Cloud Platform opens up many new possibilities and capabilities for your organization. However, "there is no free lunch". With all of these new possibilities, there's more for system administrators and engineers to control. Cluster-services offers an easy to use command line interface to modify compute partitions, Slurm accounting, and network mounted storage.

Through Fluid Numerics®' experience in developing custom cloud-HPC solutions, we've uncovered typical operation and maintenance tasks and encapsulated them in cluster-services. The cluster-services command line interface is used to modify compute partitions and to add or remove external filesystems, such as Lustre. Performing these types of operations on slurm-gcp manually requires multiple steps to ensure that the desired changes are achieved. Rather than modifying configuration files or re-deploying, use cluster-services to customize your slurm-gcp deployment.

The Fluid Numerics® Research Computing Cluster marketplace deployment comes with a command line interface, called cluster-services, for managing your resources after deployment. The cluster-services CLI allows you manage your cluster's partitions and available machines, Slurm accounting, and external filesystem mounts. 

==============
CLI Reference
==============
.. code-block::bash

    Copyright 2020 Fluid Numerics
    All Rights Reserved
    
    cluster-services is a tool used to manage fluid-slurm-gcp clusters on Google Cloud Platform.
    For more information about fluid-slurm-gcp, go to https://help.fluidnumerics.com/slurm-gcp
    
    Usage: 
      cluster-services init
      cluster-services list all [--format=<fmt>]
      cluster-services list partitions [--format=<fmt>]
      cluster-services list mounts [--format=<fmt>]
      cluster-services list slurm_accounts [--format=<fmt>]
      cluster-services update config
      cluster-services update partitions [--preview] [--config=<string>]
      cluster-services update mounts [--preview] [--config=<string>]
      cluster-services update slurm_accounts [--preview] [--config=<string>]
      cluster-services validate config [--config=<string>]
      cluster-services clear users
      cluster-services sample partitions [--format=<fmt>]
      cluster-services sample mounts [--format=<fmt>]
      cluster-services sample slurm_accounts [--format=<fmt>]
      cluster-services configure mail-relay [--config=<string>]
      cluster-services configure resolvconf [--config=<string>]
      cluster-services configure slurmdb [--config=<string>]
      cluster-services system-checks
      cluster-services -h | --help
      cluster-services --version
    
    Commands:
      init                   Initialize a cluster-config definition file using /slurm/scripts/config.yaml
      list all               List the current cluster config to stdout in the specified format.
      list partitions        List the current cluster partitions to stdout in the specified format.
      list mounts            List the current cluster mounts to stdout in specified format.
      list slurm_accounts    List the current cluster slurm_accounts to stdout in specified format.
      update config          Update the default cluster config from instance metadata item "cluster-config". 
      update partitions      Update partitions using the specified cluster config file.
      update mounts          Update mounts using the specified cluster config file.
      update slurm_accounts  Update Slurm users using the specified cluster config file.
      validate config        Validate the specified cluster configuration file.
      clear users            Remove all Slurm users from the default slurm account.
      sample partitions      Provide a sample partitions yaml-block to stdout.
      sample mounts          Provide a sample mounts yaml-block to stdout.
      sample slurm_accounts  Provide a sample slurm_accounts yaml-block to stdout. 
      configure mail-relay   Configure the postfix server to use GSuite SMTP-Relay.
      configure resolvconf   Configure the resolv.conf for multi-project deployments.
      configure slurmdb      Configure the Slurm database.
      system-checks          Perform a set of system checks for the node this is executed from.
      ci-tests               Perform system continuous integration tests
    
    Options:
      -h --help            Display this help screen
      --preview            Preview expected changes for an update, but do not execute.
      --format=<fmt>       Output format [default: yaml]
      --config=<string>    Cluster configuration file [default: /apps/cls/etc/config.yaml]


