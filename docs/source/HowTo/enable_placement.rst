##########################
Enable Placement Policies
##########################

`Placement policies <https://cloud.google.com/compute/docs/instances/define-instance-placement>`_ on Google Cloud can help you schedule compute nodes in batch that meet placement requirements. For example, a "spread placement" policy allows you to batch schedule compute nodes across multiple zones in the same region with one batch create call. On the other hand, a "compact placement" policy allows to you batch schedule nodes that are physically close to each other within a Google data center. 

The Research Computing Cluster allows you to enable spread or compact placement policies for each partition in your cluster. This guide will walk you through procedures for enabling compact placement.


==========================
Prerequisites
==========================

Compact placement policies are currently only available for compute optimized (c2) instances on Google Cloud.
Spread placement policies are currently only available for n1, n2, n2d, and c2 instances on Google Cloud.

To complete the activities in this guide, you must have root privileges on your cluster. This can be enabled by having the Comput OS Admin Login role aligned with your Gmail, Cloud Identity, or Google Workspace account.


==========================
Enable Compact Placement
=========================

1. Log in to your cluster's **controller** node via SSH.

2. Go root using :code: `sudo su`

3. Initialize cluster-services (if it has not been initialized already). On debian and Ubuntu solutions, you will need to reference the full path to cluster-services (:code:`/opt/cls/bin/cluster-services`)

.. code-block:: shell
       
    cluster-services init

4. Create a cluster configuration file

.. code-block:: shell

    cluster-services list all > config.yaml

5. Open the :code:`config.yaml` file in a text editor and navigate to the :code:`partitions.machines` block associated with the machine block that you want to enable compact placement on. **This machine block must use c2 instances** . Set the :code:`partitions[].machines[].enable_placement` boolean to `True`. Save the file and exit the text editor.

6. Preview the changes you are about to make.

.. code-block:: shell

    cluster-services update partitions --config=config.yaml --preview

7. Apply the changes

.. code-block:: shell

    cluster-services update partitions --config=config.yaml


Next time instances are created in this partition, a compact placement policy will be enforced.
