##############################
Monitoring Jobs and Resources
##############################

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
