####################
OpenFOAM
####################

`OpenFOAM <https://openfoam.org/>`_ is an open-source finite-volume based computational fluid dynamics toolkit for simulating a variety of fluid phenomena. The Research Computing Cluster (RCC) offers OpenFOAM through virtual machine images that can be easily incorporated into an existing RCC. Alternatively, if you want to get started with a click-to-deploy solution that has OpenFOAM, Paraview, and GMSH installed, you can use the `RCC-CFD Marketplace solution <https://console.cloud.google.com/marketplace/product/fluid-cluster-ops/cloud-cfd>`_.

This documentation covers

1. What is included in the RCC-CFD VM Images
2. How to get started from the `Marketplace solution <https://console.cloud.google.com/marketplace/product/fluid-cluster-ops/cloud-cfd>`_
3. How to add OpenFOAM to an existing cluster
4. How to use Target Architecture VM images for optimal performance


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



==============================================
Getting Started with the Marketplace Solution
==============================================



====================================
Add OpenFOAM to an existing cluster
====================================
If you are already running a Research Computing Cluster (RCC) from Fluid Numerics on Google Cloud, you can easily add a compute partition to your cluster that deploys compute nodes with one of the RCC-CFD images.

To add OpenFOAM to an existing cluster,

1. Log in to your cluster's **controller** instance
2. Go root

.. code-block:: shell
   
   sudo su

3. Create a temporary cluster configuration file to plan the changes to your cluster

.. code-block:: shell
   
   cluster-services list all > config.yaml

4. Open the :code:`config.yaml` in a text editor and duplicate an existing partition definition. Edit this duplicate partition to set the partition name to :code:`openfoam` and the VM image to `projects/fluid-cluster-ops/global/images/family/rcc-cfd-gcc-x86`.


.. code-block:: shell
   
   # TO DO

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

* :code:`projects/fluid-cluster-ops/global/images/family/rcc-cfd-gcc-x86` : OpenFOAM v8 built with GCC 10.3.0 and generic x86 target architecture
* :code:`projects/fluid-cluster-ops/global/images/family/rcc-cfd-gcc-zen3` : OpenFOAM v8 built with GCC 10.3.0 and zen3 (c2d instances) target architecture **(Recommended)**
* :code:`projects/fluid-cluster-ops/global/images/family/rcc-cfd-gcc-cascadelake` : OpenFOAM v8 built with GCC 10.3.0 and cascadelake (c2 instances) target architecture
* :code:`projects/fluid-cluster-ops/global/images/family/rcc-cfd-intel-cascadelake` : OpenFOAM v8 built with Intel OneAPI compilers and cascadelake (c2 instances) target architecture

Any of these images can be used to run OpenFOAM, but significant differences in performance of some OpenFOAM binaries has been noticed. When preparing for a production deployment with OpenFOAM, we recommend that you benchmark your relevant simulations using each of the above build flavors paired with the corresponding machine type on Google Cloud. 

If you need assistance with benchmarking & discovery, :doc:`reach out to Fluid Numerics support <../Support/support>`_


=================
Further Reading 
=================
