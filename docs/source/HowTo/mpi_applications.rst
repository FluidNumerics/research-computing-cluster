#####################
Run MPI Applications
#####################
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

==============
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
