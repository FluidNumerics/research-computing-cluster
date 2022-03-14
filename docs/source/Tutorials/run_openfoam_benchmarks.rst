#########################
Run OpenFOAM Benchmarks
#########################


=================
Before you begin
=================
To complete this tutorial, you will need to deploy the `RCC-CFD solution <https://console.cloud.google.com/marketplace/product/fluid-cluster-ops/rcc-cfd>`_ from the Google Cloud Marketplace. 
For OpenFOAM, we recommend using the compute optimized **c2d-standard-112** instances on Google Cloud.

===============================
Run the Aerofoil 2D Benchmark
===============================
The Aerofoil 2D Benchmark is an inexpensive proof-of-concept benchmark that can help you get familiar with running OpenFOAM simulations as a batch jobs on the RCC.

A sample batch script for creating the Aerofoil 2D simulation case is included with the RCC-CFD VM image at :code:`/opt/share/openfoam.slurm`

First, connect to the login node of the cluster via SSH.

Copy the example :code:`openfoam.slurm` batch file from :code:`/opt/share`

.. code-block:: shell

    cp /opt/share/openfoam.slurm ~/

Submit the batch job using :code:`sbatch`, specifying the number of MPI tasks you want to launch with using the :code:`--ntasks` flag. 

In the example below, we are using 8 MPI tasks, 2GB memory, and a partition called "openfoam".

.. code-block:: shell

    sbatch --ntasks=8 --mem=2G --partition=openfoam openfoam.slurm


Note: Compute nodes are created as needed when jobs are submitted. For this first job submission, it can take up to 3 minutes for the job to start.

Wait for the job to complete. This benchmark is configured to compute the steady state of a laminar flow past a NACA0012 Aerofoil.

When the job completes, check the contents of :code:`rsl.out.0000` to verify that you see the statement :code:`wrf: SUCCESS COMPLETE OpenFOAM`.

=====================================
Visualize the results with Paraview
=====================================


======================
Further Reading
======================

* In-depth codelab on running the Aerofoil demo
* 
