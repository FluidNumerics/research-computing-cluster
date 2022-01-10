#########################
Submit Interactive Jobs
#########################
The interactive workflows described here use a combination of salloc and srun command line interfaces. 

For all interactive workflows, you should be aware that you are charged for each second of allocated compute resources. It is best practice to set a wall-time when allocating resources. This practice helps avoid situations where you will be billed for idle resources you have reserved.

==============================
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

=======================================================
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
