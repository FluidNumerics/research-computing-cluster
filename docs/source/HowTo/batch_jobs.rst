##################
Submit Batch Jobs
##################


Batch jobs are useful when you have an application that can run unattended for long periods of time. You run a batch job by using the sbatch command with a batch file.

=====================
Writing a batch file
=====================
A batch file consists of two sections

1. Batch header - Communicates settings to Slurm that specify your slurm account, the compute partition to submit the job to, the number of tasks to run, the amount of resources (cpu, gpu, and memory), and the task affinity.

2. Shell script instructions

Below is a simple example batch file:

.. code-block::bash

    #!/bin/bash
    #SBATCH --account=my-slurm-account
    #SBATCH --partition=this-partition
    #SBATCH --job-name=example_job_name
    #SBATCH --ntasks=1
    #SBATCH --ntasks-per-node=1
    #SBATCH --gres=gpu:2
    #SBATCH --time=00:05:00
    #SBATCH --output=serial_test_%j.log
    
    hostname

The above batch file has multiple constraints that dictate how the job will be executed. 

* :code:`--account=my-slurm-account` indicates that you are using the "my-slurm-account"  to log the resource usage against.
* :code:`--partition=this-partition` requests the job execute on a partition called "this-partition"
* :code:`--job-name=’name’`  sets the job name 
* :code:`--ntasks=1` advises the slurm controller that job steps run within the allocation will launch a maximum of 1 tasks
* :code:`--ntasks-per-node=1` When used by itself, this constraint requests that 1 task per node be invoked. When used with --ntasks, --ntasks-per-node is treated as the maximum count of tasks per node. 
* :code:`--gres=gpu:2` indicates that 2 GPUs are requested to execute this batch job 
* :code:`--time=00:05:00` sets a total run time of 5 minutes for job allocation. 
* :code:`--output=name.log` out creates a file containing the batch script’s stdout and stderr.

`SchedMD’s sbatch documentation <https://slurm.schedmd.com/sbatch.html>`_ provides a more complete description of the sbatch command line interface and the available options for specifying resource requirements and task affinity.

Batch jobs are submitted using the sbatch command. 

.. code-block:: shell

    sbatch example.batch


Once you have submitted your batch job, you can check the status of your job with the squeue command. Since the RCC is an autoscaling cluster, you may notice that your job is in a configuring (CF) state for some time before starting. This happens because compute nodes are created when needed to meet the compute resource demands on-the-fly. This process can take anywhere from 30s - 3 minutes.
