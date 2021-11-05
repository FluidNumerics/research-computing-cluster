####################
Run WRF Benchmarks
####################


=================
Before you begin
=================
To complete this tutorial, you will need to deploy the `RCC-WRF solution <https://console.cloud.google.com/marketplace/product/fluid-cluster-ops/rcc-wrf>`_ from the Google Cloud Marketplace. You can follow the instructions in the :doc:`Deploy from Marketplace Quickstart <../QuickStart/deploy_from_marketplace>`.

For WRF, we recommend using the compute optimized **c2-standard-60** instances on Google Cloud.

=============================
Run the CONUS 12km Benchmark
=============================
To run the CONUS 12km benchmark, you will submit a Slurm batch job. The input decks and a sample batch script for this benchmark are included in the wrf-gcp VM image under /apps/share/benchmarks/conus-12km.

First, connect to the login node of the cluster via SSH.

Copy the example wrf-conus.sh batch file from /apps/share

.. code-block:: shell

    cp /apps/share/wrf-conus12.sh ~/

Submit the batch job using :code:`sbatch`, specifying the number of MPI tasks you want to launch with using the :code:`--ntasks` flag. 

In the example below, we are using 24 MPI tasks. With c2-standard-8 instances, the cluster will provision 3 nodes and distribute the tasks evenly across these compute nodes.

.. code-block:: shell

    sbatch --ntasks=24 wrf-conus12.sh


Note: Compute nodes are created as needed when jobs are submitted. For this first job submission, it can take up to 3 minutes for the job to start.

Wait for the job to complete. This benchmark is configured to run a 2-hour forecast, which takes about 6 minutes to complete with 24 ranks. You can monitor the status of your job with :code:`squeue`.

When the job completes, check the contents of :code:`rsl.out.0000` to verify that you see the statement :code:`wrf: SUCCESS COMPLETE WRF`.

.. code-block:: shell

    $ tail -n1 ${HOME}/wrf-benchmark/rsl.out.0000
    d01 2018-06-17_06:00:00 wrf: SUCCESS COMPLETE WRF


=============================
Run the CONUS 2.5km Benchmark
=============================
To run the CONUS 2.5km benchmark, you will submit a Slurm batch job. The input decks and a sample batch script for this benchmark are included in the wrf-gcp VM image under /apps/share/benchmarks/conus-2.5km.

First, connect to the login node of the cluster via SSH.

Copy the example wrf-conus.sh batch file from /apps/share

.. code-block:: shell

    cp /apps/share/wrf-conus2p5.sh ~/

For ideal performance, we recommend using compact placement for your partition. If you have not enabled compact placement for your compute partitionSee :doc:`How to enable compact placement <../HowTo/enable_placement>` for more details.

Submit the batch job using :code:`sbatch`, specifying the number of MPI tasks you want to launch with using the :code:`--ntasks` flag. 

In the example below, we are using 480 MPI tasks. With c2-standard-60 instances, the cluster will provision 8 nodes and distribute the tasks evenly across these compute nodes.

.. code-block:: shell

    sbatch --ntasks=480 --partition=PARTITION wrf-conus2p5.sh


Note: Compute nodes are created as needed when jobs are submitted. For this first job submission, it can take up to 3 minutes for the job to start.

Wait for the job to complete. This benchmark is configured to run a 6-hour forecast, which takes about 50 minutes to complete with 480 ranks. You can monitor the status of your job with :code:`squeue`.

When the job completes, check the contents of :code:`rsl.out.0000` to verify that you see the statement :code:`wrf: SUCCESS COMPLETE WRF`.

.. code-block:: shell

    $ tail -n1 ${HOME}/wrf-benchmark/rsl.out.0000
    d01 2018-06-17_06:00:00 wrf: SUCCESS COMPLETE WRF


