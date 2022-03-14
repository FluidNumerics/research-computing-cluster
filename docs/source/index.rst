.. research-computing-cluster documentation master file, created by
   sphinx-quickstart on Wed Sep  8 15:35:38 2021.
   You can adapt this file completely to your liking, but it should at least
   contain the root `toctree` directive.

Research Computing Cluster
======================================
The Research Computing Cluster is a cloud-native (hybrid-capable), autoscaling cluster that deploys on Google Cloud. The RCC comes with a Slurm job scheduler, Spack, Singularity, and a suite of compilers and developer tools to help you get started quickly on the cloud with a cluster that has the look-and-feel of on premise resources.




.. toctree::
   :caption: Quick Start
   :name: quickstarttoc
   :titlesonly:

   QuickStart/deploy_from_marketplace
   QuickStart/deploy_with_terraform

.. toctree::
   :caption: How To
   :name: howto
   :titlesonly:

   HowTo/manage_spack_packages
   HowTo/batch_jobs
   HowTo/interactive_jobs
   HowTo/monitor_jobs
   HowTo/mpi_applications
   HowTo/gpu_applications
   HowTo/initialize_cluster_services
   HowTo/customize_compute_partitions
   HowTo/run_a_singularity_container
   HowTo/enable_placement
   HowTo/mount_unmount_filesystems

.. toctree::
   :caption: Research Applications
   :name: tutorialstoc
   :titlesonly:

   ResearchApplications/openfoam

.. toctree::
   :caption: Tutorials
   :name: tutorialstoc
   :titlesonly:

   Tutorials/run_wrf_benchmarks

.. toctree::
   :caption: Reference Guide
   :name: referencetoc
   :titlesonly:

   Reference/architecture
   Reference/cluster_services

.. toctree::
   :caption: Managed Services
   :name: managedtoc
   :titlesonly:

   Managed/user_onboarding

.. toctree::
   :caption: Support
   :name: supporttoc
   :titlesonly:

   Support/support


Indices and tables
==================

* :ref:`genindex`
* :ref:`modindex`
* :ref:`search`
