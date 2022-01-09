##################
Getting Work Done
##################


==================
Submit Batch Jobs
==================
Batch jobs are useful when you have an application that can run unattended for long periods of time. You run a batch job by using the sbatch command with a batch file.

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

Submitting a batch job
========================
Batch jobs are submitted using the sbatch command. 

.. code-block:: shell

    sbatch example.batch


Once you have submitted your batch job, you can check the status of your job with the squeue command. Since the RCC is an autoscaling cluster, you may notice that your job is in a configuring (CF) state for some time before starting. This happens because compute nodes are created when needed to meet the compute resource demands on-the-fly. This process can take anywhere from 30s - 3 minutes.

=================
Interactive Jobs
=================
The interactive workflows described here use a combination of salloc and srun command line interfaces. 

For all interactive workflows, you should be aware that you are charged for each second of allocated compute resources. It is best practice to set a wall-time when allocating resources. This practice helps avoid situations where you will be billed for idle resources you have reserved.

Allocate and Execute Workflow
==============================
With slurm, you can allocate compute resources that are reserved for your sole use. This is done using the salloc command. As an example, you can reserve exclusive access on one compute node for an hour on the default partition

.. code-block:: shell

    salloc --account=my-account --partition=this-partition --time=1:00:00 --N1 --exclusive

Once resources are allocated, Slurm responds with a job id. From here, you can execute commands on compute resources using :code:`srun`. srun is a command line interface for executing “job steps” in slurm. You can specify how much of the allocated compute resources to use for each job step. For example, the srun command below executes provides access to 4 cores for executing ./my-application.

.. code-block:: shell

    srun -n4 ./my-application


To release your allocation before the requested wall-time, you can use scancel

.. code-block:: shell

    scancel <job-id>


After cancelling your job, or after the wall-clock limit is exceeded, Slurm will automatically delete compute nodes for you.

Interactive Shell Workflow (with Graphics Forwarding)
=======================================================
If your workflow requires graphics forwarding from compute resources, you can allocate resources as before using salloc, e.g.,

.. code-block:: shell

    salloc --account=my-account --partition=this-partition --time=1:00:00 --N1 --exclusive

Once resources are allocated, you can launch a shell on the compute resources with X11 forwarding enabled.

.. code-block:: shell

    srun -N1 --pty --x11 /bin/bash

Once you are complete with your work, exit the shell and release your resources.

.. code-block:: shell

    exit
    scancel <job-id>

Run MPI Applications
=====================
The RCC comes with OpenMPI preinstalled and integrated with the Slurm job scheduler. OpenMPI can be brought into your path by using the :code:`spack load` command. Since OpenMPI is built using various compilers, you need to also specify which compiler stack you are using. For example, the following command loads openmpi with the GCC 10.2.0 compiler. 

.. code-block:: shell

    spack load openmpi % gcc@10.2.0

To see all available openmpi builds, use :code:`spack find openmpi`.

Once loaded in your path, you can build your application with OpenMPI using mpif90, mpic++, or mpicc. Once compiled you can run your applications using srun either through interactive jobs or batch jobs. Below is a simple example of running an MPI application with 8 MPI ranks, using srun.

.. code-block:: shell

    #!/bin/bash
    #SBATCH --account=my-slurm-account
    #SBATCH --partition=this-partition
    #SBATCH --ntasks=8
    #SBATCH --ntasks-per-node=8
    
    spack load openmpi % gcc@10.2.0
    srun -n8 ./my-application

Task Affinity
==============

Understanding Slurm Resource flags
-----------------------------------
Slurm allows you to request specific amounts of vCPU, memory, and GPUs when submitting a job. Commonly used flags in Slurm batch headers with their purposes are listed below

* :code:`--ntasks` : The number of tasks that need to be executed. Typically, for MPI jobs, this is equivalent to the number of MPI ranks.
* :code:`--cpus-per-task` : The number of logical cpus (vCPUs) to assign to each task. On modern hardware, a physical core can support two hyperthreads (logical CPUs). Some codes benefit from running on all hyperthreads, while others do not.
* :code:`--mem-per-cpu` : The amount of memory need for each vCPU used in launching jobs. By default, this value is set to the total VM memory divided by the number of vCPUs.
* :code:`--gres` : A flag for specifying any generic resources to assign to the job. Currently, GPUs are made available as generic resources.
When a batch job is launched and the resources requested are allocated, you have the ability to specify how to map individual tasks onto the allocated resources. This mapping of task to hardware is called the Task Affinity. Task affinity can be controlled with mpirun/mpiexec or Slurm's srun. Proper task affinity is necessary to obtain optimal performance of your application.

Specifying task affinity with mpirun
-------------------------------------
OpenMPI comes pre-installed on RCC systems and is capable of specifying task affinity.

* :code:`--report-bindings` : Shows how MPI ranks are bound to resources
* :code:`--bind-to` : Specify which hardware resource to bind each MPI rank to. Options are hwthread, core, socket, node. Binding to a specific component of hardware prevents the process from leaving the assigned hardware component.
* :code:`--map-by` : Specify how MPI ranks are mapped to hardware. Options are hwthread, core, socket, node.
* :code:`--np` : Specify the number of MPI ranks to launch your application with

Map MPI ranks to physical cores
--------------------------------
This Slurm batch file template can be used to align two logical CPUs per task. The mpirun flags used bind the MPI ranks to hardware cores and map MPI ranks in sequence on the physical cores. In this scenario, each MPI rank is executed on its own physical core, but can switch between the two available hyperthreads on each core.

.. code-block:: shell

    #!/bin/bash
    #SBATCH --partition=c2-standard-60
    #SBATCH --ntasks=30
    #SBATCH --cpus-per-task=2
    
    spack load openmpi % gcc@10.2.0
    mpirun -np 30 --map-by core --bind-to core --report-bindings
    
Map MPI ranks to hardware threads
----------------------------------
This Slurm batch file template can be used to align one logical CPUs per task. The mpirun flags used bind the MPI ranks to hardware cores and map MPI ranks in sequence on the physical cores. In this scenario, each MPI rank is executed on its own physical core, but can switch between the two available hyperthreads on each core.

.. code-block:: shell

    #!/bin/bash
    #SBATCH --partition=c2-standard-60
    #SBATCH --ntasks=30
    #SBATCH --cpus-per-task=1
    
    spack load openmpi % gcc@10.2.0
    mpirun -np 30 --map-by core --bind-to hwthread --report-bindings
    
Specifying task affinity with srun
-----------------------------------
Applications built with OpenMPI expect that each MPI rank is assigned to slots on compute nodes. When working with Slurm, the number of slots is equivalent to the number of tasks ( --ntasks). Additionally, you are able to control the task affinity, which means you can specify (as detailed as you like) how to map each MPI rank to the underlying compute hardware. 

The easiest place to get started, if you are unsure of an ideal mapping, is to use the :code:`--hint` flag with srun. This flag allows you to suggest to srun whether your application is compute bound (:code:`--hint=compute_bound`), memory bound (:code:`--hint=memory_bound)`, or communication intensive (:code:`--hint=multithread`). Additionally, you can add the :code:`--cpu-bind=verbose` flag to report the task affinity back to :code:`STDOUT`.

For compute bound applications, :code:`--hint=compute_bound` will map tasks to all available cores.

.. code-block:: shell

    srun -n8 --hint=compute_bound --cpu-bind=verbose./my-application

For memory bound applications, :code:`--hint=memory_bound` will map tasks to one core for each socket, giving the highest possible memory bandwidth for each task.

.. code-block:: shell

    srun -n8 --hint=compute_bound --cpu-bind=verbose./my-application

For communication intensive applications, :code:`--hint=multithread` will map tasks to hardware threads (hyperthreads/virtual CPUs)

.. code-block:: shell

    srun -n8 --hint=multithread --cpu-bind=verbose./my-application

In addition to hints, you can use the following high level flags

* :code:`--sockets-per-node` : Specify the number of sockets to allocate per VM
* :code:`--cores-per-socket` : Specify the number of cores per socket to allocate
* :code:`--threads-per-core` : Specify the number of threads per core to allocate

Run GPU Accelerated Applications
=================================
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
    
Monitoring Jobs and Resources
==============================

Checking Slurm job status
--------------------------
Slurm's :code:`squeue` command  can be used to keep track of jobs that have been submitted to the job queue.

.. code-block:: shell

    squeue

You can use optional flags, such as :code:`--user` and :code:`--partition` to filter results based on username or compute partition associated with each job.

.. code-block:: shell

    squeue --user=USERNAME --partition=PARTITION

Slurm jobs have a status code associated with them which change during the lifespan of the job

* :code:`CF` | The job is in a configuring state. Typically this state is seen when autoscaling compute nodes are being provisioned to execute work.
* :code:`PD` | The job is in a pending state. 
* :code:`R` | The job is in a running state.
* :code:`CG` | The job is in a completing state and the associated compute resources are being cleaned up.
* :code:`(Resources)` | There are insufficient resources available to schedule your job at the moment. 

Checking Slurm compute node status
-----------------------------------
Slurm's :code:`sinfo` command  can be used to keep track of the compute nodes and partitions available for executing workloads.

.. code-block:: shell

    sinfo

Compute nodes have a status code associated with them that change during the lifespan of each node. A few common state codes are shown below. A more detailed list can be found in SchedMD's documentation.

* :code:`idle` | The compute node is in an idle state and can receive work. 
* :code:`down` | The compute node is in a down state and may need to be drained and placed back in down state. Downed nodes are also symptomatic of other issues on your cluster, such as insufficient quota or improperly configured machine blocks.
* :code:`mixed` | A portion of the compute nodes resources have been allocated, but additional resources are still available for work.
* :code:`allocated` | The compute node is fully allocated

Additionally, east state code has a modifier with the following meanings
* :code:`~` | The compute node is in a "cloud" state and will need to be provisioned before receiving work
* :code:`#` | The compute node is currently being provisioned (powering up)
* :code:`%` | The compute node is currently being deleted (powering down)
