####################
OpenFOAM & Paraview
####################

`OpenFOAM <https://openfoam.org/>`_ is an open-source finite-volume based computational fluid dynamics toolkit for simulating a variety of fluid phenomena. `Paraview <https://paraview.org/>`_ is an open-source toolkit for visualizing scientific data and is capable of leveraging clusters of compute instances for rendering large datasets. 

The Research Computing Cluster (RCC) offers OpenFOAM and Paraview through virtual machine images that can be easily incorporated into an existing RCC. Alternatively, if you want to get started with a click-to-deploy solution that has OpenFOAM, Paraview, and GMSH installed, you can use the `RCC-CFD Marketplace solution <https://console.cloud.google.com/marketplace/product/fluid-cluster-ops/cloud-cfd>`_.


This documentation covers

1. What is included in the RCC-CFD VM Images
2. How to add OpenFOAM to an existing cluster
3. Target Architecture VM images
4. Basics of connecting Paraview Server on the RCC to your local Paraview client

If you'd like to deploy RCC-CFD from the Google Cloud Marketplace, see the :doc:`Deploy from Marketplace <../QuickStart/deploy_from_marketplace>` documentation.
If you'd like to deploy RCC-CFD using Terraform, see the :doc:`Deploy with Terraform <../QuickStart/deploy_with_terraform>` documentation.


==========================
RCC-CFD VM Image Overview
==========================
The RCC-CFD VM Image is built using the open-source `RCC-Apps <https://github.com/fluidnumerics/rcc-apps>`_ image baking repository. Marketplace images are quality controlled and benchmarked before release and additionally include the cluster-services CLI tool for customizing your cluster post-deployment.

---------------
Image Contents
---------------

OpenFOAM
---------

The RCC-CFD VM image uses `Spack <https://github.com/spack/spack>`_ to install a compiler, MPI flavor (OpenMPI for all builds), OpenFOAM, and the necessary dependencies. All packages are installed under the :code:`/opt/spack` directory. A Spack environment file, which dictates the specific package versions and compilers, is maintained under :code:`/opt/spack-pkg-env`. To expose OpenFOAM and the other necessary binaries to each user's default :code:`$PATH`, all package binaries are symlinked to :code:`/opt/view/bin`. When a user logs in, the :code:`/etc/profile.d/z10_spack_environment.sh` script is sourced automatically, so that OpenFOAM binaries are made available upon login.

To help you quickly prove concept for running OpenFOAM on Google Cloud, we've provided job submission scripts and input decks for the `Aerofoil <https://www.openfoam.com/documentation/guides/latest/doc/verification-validation-naca0012-airfoil-2d.html>`_ and `Dam Break (2.8M) <https://cfd.direct/openfoam/user-guide/v6-dambreak/>`_ benchmarks. The directories for each of these cases can be found under :code:`/opt/share`

To summarize this section,

* :code:`/opt/spack` hosts the Spack package manager and all of the packages installed by Spack.
* :code:`/opt/spack-pkg-env` hosts the Spack environment file that dictates what packages and versions are installed alonside which compiler is used to install them.
* :code:`/opt/view` hosts a consolidated view for the Spack environment using symlinks from `/opt/spack`
* :code:`/opt/share` hosts the simulation case directories for the Aerofoil and Dam Break (2.8M) benchmarks for proof-of-concept with this image.
* :code:`/etc/profile.d/z10_spack_environment.sh` defines the necessary environment variables for exposing the Spack environment to each user automatically when they log in.


Paraview
---------
The RCC-CFD VM image includes `Paraview <https://www.paraview.org/>`_, a scalable tool for scientific data visualization. Paraview is commonly used for visualizing OpenFOAM model output, in addition to output from other CFD applications. Paraview is installed using pre-compiled downloads from paraview.org with MPI and EGL enabled. MPI-built paraview allows for parallel rendering, a particularly useful feature for large datasets. The EGL backend allows for you to take advantage of Nvidia GPUs for many rendering tasks as well. 

Paraview is installed under :code:`/opt/paraview`. When a user logs in, the :code:`/etc/profile.d/z11_paraview.sh` script is sourced automatically so that Paraview is found in the default serach path. We've also included scripts that can help you easily connect a local Paraview client on your workstation to a Paraview server running in Google Cloud underneath :code:`/opt/share/`. These scripts include a PVSC XML file in addition to a template job submission script that handles launching paraview server on compute nodes as well as establishing a reverse ssh connection to your local client.

To summarize this section,

* :code:`/opt/paraview` hosts Paraview binaries and shared object libraries for Paraview dependencies
* :code:`/opt/share` hosts a PVSC XML file and template job submission script that are used to connect your local Paraview client to a Paraview Server running in Google Cloud through RCC
* :code:`/etc/profile.d/z11_paraview.sh` defines the necessary environment variables for exposing the Paraview binaries to each user automatically when they log in.


Gmsh
-----
The RCC-CFD VM image includes `Gmsh <https://gmsh.info/>`_, an open-source mesh generator capable of creating mesh files for OpenFOAM simulations. The provided install of Gmsh has OpenCascade enabled, which allows you to create mesh files starting from OpenCascade CAD files. While Gmsh is a graphical application, users are encouraged to leverage Gmsh in a headless mode to process Gmsh scripts or with `pygmsh <https://github.com/nschloe/pygmsh>`_.

Gmsh is installed under :code:`/opt/gmsh`. When a user logs in, the :code:`/etc/profile.d/z11_gmsh.sh` script is sourced automatically so that Gmsh is found in the default search path.

To summarize this section,

* :code:`/opt/gmsh` hosts the Gmsh binaries
* :code:`/etc/profile.d/z11_gmsh.sh` defines the necessary environment variables for exposing the Gmsh binary to each user automatically when they log in.


====================================
Add OpenFOAM to an existing cluster
====================================
If you are already running a Research Computing Cluster (RCC) from Fluid Numerics on Google Cloud, you can easily add a compute partition to your cluster that deploys compute nodes with one of the RCC-CFD images.

To add OpenFOAM to an existing cluster,

1. Log in to your cluster's **controller** instance
2. Go root

.. code-block:: shell
   
   sudo su

3. Create a temporary cluster configuration file to plan the changes to your cluster. If this is your first time running the :code:`cluster-services` command, you will need to initialize this :code:`cluster-services` command line interface, as shown below.

.. code-block:: shell
   
   cluster-services init
   cluster-services list all > config.yaml

4. Open the :code:`config.yaml` in a text editor and duplicate an existing partition definition. Edit this duplicate partition to set the partition name to :code:`openfoam` and the VM image to `projects/fluid-cluster-ops/global/images/family/rcc-cfd-gcc-x86`.


5. Preview the changes to your cluster, using :code:`cluster-services`


.. code-block:: shell
   
   cluster-services update partitions --config=config.yaml --preview

6.  When you are ready to apply the changes, you can run the same command while ommitting the :code:`--preview` flag.

.. code-block:: shell
   
   cluster-services update partitions --config=config.yaml


==========================================================
Optimize Performance with Target Architecture VM Images
==========================================================
Google Cloud offers a variety of compute platforms and knowing which platform will provide the best performance and cost a'priori for a given simulation is challenging. Currently, Fluid Numerics' recommends using the c2d (AMD Epyc Milan) instances and OpenFOAM compiled with GCC 10.3.0 with the zen3 target optimizations. This recommendation is based on benchmarks of :code:`interFoam`. For other OpenFOAM applications, or even user-built solvers, this platform may be optimal but is not guaranteed. 

To help facilitate performance discovery, Fluid Numerics provides the following target architecture VM images

========================== ===================== ==================
Image Family               Target Architecture   Machine Type
========================== ===================== ==================
`rcc-cfd-gcc-x86`          x86                   Any
`rcc-cfd-gcc-zen3`         zen3                  c2d
`rcc-cfd-gcc-cascadelake`  cascadelake           c2
========================== ===================== ==================

The image self-link, which is used in your cluster configuration file or in a terraform deployment configuration, is :code:`projects/fluid-cluster-ops/global/images/family/[FAMILY]`, where :code:`[FAMILY]` is one of the image families listed in the first column of the table above.


Any of these images can be used to run OpenFOAM, but significant differences in performance of some OpenFOAM binaries has been noticed. When preparing for a production deployment with OpenFOAM, we recommend that you benchmark your relevant simulations using each of the above build flavors paired with the corresponding machine type on Google Cloud. 

If you need assistance with benchmarking & discovery, :doc:`reach out to Fluid Numerics support <../Support/support>`


======================================
Paraview Server to Client Connections
======================================
For high resolution simulations, visualizing and post-processing CFD data on your local work station is either not possible or too slow to be practical. The RCC-CFD VM image comes with Paraview server, a PVSC XML file, and a batch script that can be used to connect your local Paraview client to Paraview server running in the cloud. With this configuration, the computations required for rendering are executed on Google Cloud and the resulting graphics are sent back to your local client. When working with large datasets, this can result in a more interactive data visualization experience and help you develop post-processing pipelines faster.

Prerequisites
---------------
To get started, you will need to have Paraview 5.10.0 installed on your local workstation. If you install a different version of Paraview, you may not be able to establish a connection to Paraview Server on the RCC. Visit https://www.paraview.org/download/ to download Paraview 5.10.0 for your operating system.

These instructions assume that you have deployed an RCC-CFD cluster and have configured `OS Login <https://cloud.google.com/compute/docs/oslogin>`_ for your account so that you can SSH to Google Cloud VM instances using third party SSH utilities.

If you'd like to deploy RCC-CFD from the Google Cloud Marketplace, see the :doc:`Deploy from Marketplace <../QuickStart/deploy_from_marketplace>` documentation.
If you'd like to deploy RCC-CFD using Terraform, see the :doc:`Deploy with Terraform <../QuickStart/deploy_with_terraform>` documentation.

You will need to create a `firewall rule <https://cloud.google.com/vpc/docs/using-firewalls>`_ for the network your cluster is deployed to that allows for tcp communications on port 11000 from your local workstation. If you deployed RCC-CFD using Terraform, this firewall rule is created for you.


Connecting Paraview Client to Paraview Server
-----------------------------------------------
The instructions given below apply for Linux and MacOS workstations.

1. Find the external IP address of your cluster's login node using the gcloud SDK. In the command below, replace :code:`[PROJECT-ID]` with the Google Cloud project ID where your cluster is deployed.

.. code-block:: shell
   
   gcloud compute instances list --project=[PROJECT-ID]

   
2. On your local workstation, use :code:`scp` to copy the :code:`paraview-gcp.pvsc` server connection file. In the command below, :code:`[USERNAME]` is your OS Login username and `[IP-ADDRESS]` is the external IP address found in the previous step. If you do not know your OS Login username, use :code:`gcloud compute os-login describe-profile | grep username` to display your username.

.. code-block:: shell
   
   mkdir -p ~/paraview/
   scp [USERNAME]@[IP-ADDRESS]:/opt/share/paraview-gcp.pvsc ~/paraview/paraview-gcp.pvsc

3. Start paraview on your local client.

4. Using the toolbar, click on the "Connect to Server" icon and then click on "Load Server". In the file search menu that opens, navigate to :code:`~/paraview/` and open the :code:`paraview-gcp.pvsc` file and then click "Connect"

5. Use the drop-down menu to select the terminal client; this will be the path to XTerm for your system. Set the full path to the :code:`ssh` command on your system (In your terminal, you can find this by running :code:`which ssh`. Set the SSH Username to your OS Login username. If you are using a non-default path for your public SSH key, you can modify the Public SSH Key field. Set the Login Node IP address to the external IP address found in step 1. You can leave the "Remote Script" and "Slurm Account" at their default values. Set the Slurm partition to the name of the partition you want to deploy Paraview on and set the number of processes to the number of MPI processes to use to run paraview server. Last, set the amount of memory (in GB) per MPI process and the number of hours to reserve the nodes for. When ready, click Ok. 
   
   

This will open an XTerm window where a command will be executed to submit the Remote Script via :code:`sbatch`.  This will cause compute nodes to be provisioned and Paraview server to start and establish a reverse SSH connection to your local client. From here, you will be able to access files on your RCC for rendering.


=================
Further Reading 
=================

* :doc:`Get started using the Marketplace deployment <../QuickStart/deploy_from_marketplace>`
* :doc:`Get started using Terraform <../QuickStart/deploy_with_terraform>`
* `Codelab - Run the NACA0012 Aerofoil (2D) Benchmark <https://fluidnumerics.github.io/rcc-codelabs/cloud-cfd/run-openfoam-on-gcp-with-cloud-cfd/#0>`_
