################################
Initialize cluster-services
################################

The :code:`cluster-services` command line interface provides a convenient mechanism to customize your cluster by simply defining a yaml dictionary. It can be used to adjust compute partitions, network attached storage, and slurm accounting on-the-fly. Under-the-hood, :code:`cluster-services` carries out complex workflows for adjusting your cluster on-the-fly.

Before you begin using :code:`cluster-services` you must initialize the CLI. This step creates an initial yaml dictionary compatible with cluster-services from the slurm-gcp configuration file (:code:`/slurm/scripts/config.yaml`) and sets up a symbolic link from :code:`/apps/cls/etc/slurm/scripts/config.yaml` to :code:`/slurm/scripts/config.yaml` so that updates to your cluster configuration propagate throughout your cluster.

To initialize :code:`cluster-services`,

1. Log in to your cluster's **controller** instance
2. Go root

.. code-block:: shell

    sudo su


3. Run the following command to initialize cluster-services. On Debian and Ubuntu solutions, you will need to reference the full path to cluster-services (:code:`/apps/cls/bin/cluster-services`)



.. code-block:: shell

    cluster-services init

