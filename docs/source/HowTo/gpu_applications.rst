#################################
Run GPU Accelerated Applications
#################################
The RCC comes with the CUDA toolkit (/usr/local/cuda) and ROCm (/opt/rocm) preinstalled and configured to be in your default path. Currently, the RCC and Google Cloud Platform only offer Nvidia GPUs.

Provided some of your cluster's compute partitions have GPUs attached, you can use the :code:`--gres=gpu:N` flag, where N is the number of GPUs needed per node. 

.. code-block:: shell

    #!/bin/bash
    #SBATCH --account=my-slurm-account
    #SBATCH --partition=this-partition
    #SBATCH --ntasks=1
    #SBATCH --ntasks-per-node=1
    #SBATCH --gres=gpu:1
    
    ./my-application

Multi-GPU with 1 MPI rank per GPU
-----------------------------------
When submitting jobs to run on multiple GPUs, you may find it necessary to bind MPI ranks to GPUs on the same node.  In the example below, we assume that you have 8 GPUs per node, and you want to run 16 MPI tasks, with 1 MPI rank per GPU

.. code-block:: shell

    #!/bin/bash
    #SBATCH --account=my-slurm-account
    #SBATCH --partition=this-partition
    #SBATCH --ntasks=16
    #SBATCH --ntasks-per-node=8
    #SBATCH --gres=gpu:8
    
    srun -n16 --accel-bind=gpu ./my-application
