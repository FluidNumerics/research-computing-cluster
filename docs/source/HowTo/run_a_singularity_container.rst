=========================================
Deploy Singularity and Docker Containers
=========================================

Containers are becoming a popular tool in research computing to enhance application portability and research reproducibility. `Singularity <https://singularity.hpcng.org/>`_ is an open-source secure container platform intended for high performance computing and research computing.

The Research Computing Cluster (RCC) comes with Singularity pre-installed and can be used to run Docker and Singularity containers. We encourage you to use `Google Cloud Build <https://cloud.google.com/build>`_ to support continuous integration and containerization of your application, `Google Container Registry <https://cloud.google.com/container-registry>`_ to host a private Docker registry, and `Google Cloud Storage <https://cloud.google.com/storage>`_ to host Singularity images.


This documentation will walk through how to deploy containers on the RCC.

Deploy a Docker Image
=======================
Singularity can be used to deploy a Docker image from a public or private registry. This is usually done by converting a Docker image to a Singularity image using :code:`singularity pull` and running with :code:`singularity exec`. When using a private registry, it is easiest to use `Google Container Registry <https://cloud.google.com/container-registry>`_, since credentialling is handled through Google IAM policies associated with your cluster's service account.

For other private registries, see `Making use of private images <https://singularity.hpcng.org/user-docs/master/singularity_and_docker.html#making-use-of-private-images-from-docker-hub>`_.

The directions given below assume that you are logged in to your cluster's login node. 

To convert a Docker image to a Singularity image, use :code:`singularity pull`.

.. code-block:: shell

    spack load singularity
    singularity pull docker://gcr.io/PROJECT-ID/IMAGE-NAME ${HOME}/IMAGE-NAME.sif 

In the example/template above, we assume that you are using Google Container Registry (gcr.io). In practice, you will need to replace :code:`PROJECT-ID` with your Google Cloud project ID, and :code:`IMAGE-NAME` with the name of the Docker image.

After you've converted your Docker image to a Singularity image, you can deploy a Singularity container using :code:`singularity exec`.

.. code-block:: shell

    singularity exec ${HOME}/IMAGE-NAME.sif

By default, the Singularity container will mount a number of directories, including :code:`/home` and :code:`/tmp`. This allows you to have read/write access to your home directory from within the container. If you need to mount any other directories, you can use the :code:`--bind` flag.

.. code-block:: shell

    singularity exec --bind /path/to/host/directory:/path/to/container/mount ${HOME}/IMAGE-NAME.sif

The :code:`--bind` flag expects to be given two arguments, separated by a colon :code:`:`. The first argument is the path on the cluster that you want to mount to the container and the second argument is the path to mount this directory to within the container. For more information on this topic, see `Bind Paths and Mounts in the Singularity documentation <https://singularity.hpcng.org/user-docs/master/bind_paths_and_mounts.html>`_.

For more information on using Singularity to work with Docker images, see `Support for Docker and OCI Singularity documentation <https://singularity.hpcng.org/user-docs/master/singularity_and_docker.html>`_.


Deploy a Singularity Image from Cloud Storage
==================================================
When building Singularity images with Google Cloud build, the Singularity image files are treated as artifacts, which are posted to Google Cloud Storage. You can read more about build artifacts on the `Google Cloud Build Artifacts documentation <https://cloud.google.com/build/docs/building/store-build-artifacts>`_ and how to create Singularity images with Google Cloud Build from `this community tutorial <https://cloud.google.com/community/tutorials/singularity-containers-with-cloud-build>`_.

The directions given below assume that you are logged in to your cluster's login node and that you have your Singularity image hosted in Google Cloud Storage. 

To copy your Singularity image to the cluster, you can use the :code:`gsutil` command.
.. code-block:: shell

    gsutil cp gs://YOUR-GCS-BUCKET/PATH/TO/IMAGE-NAME.sif ${HOME}/IMAGE-NAME.sif 

In the example/template above, you will need to replace :code:`PROJECT-ID` with your Google Cloud project ID, and :code:`IMAGE-NAME` with the name of the Docker image.

After you've copied your Singularity image onto the cluster, you can deploy a Singularity container using :code:`singularity exec`.

.. code-block:: shell

    singularity exec ${HOME}/IMAGE-NAME.sif

By default, the Singularity container will mount a number of directories, including :code:`/home` and :code:`/tmp`. This allows you to have read/write access to your home directory from within the container. If you need to mount any other directories, you can use the :code:`--bind` flag.

.. code-block:: shell

    singularity exec --bind /path/to/host/directory:/path/to/container/mount ${HOME}/IMAGE-NAME.sif

The :code:`--bind` flag expects to be given two arguments, separated by a colon :code:`:`. The first argument is the path on the cluster that you want to mount to the container and the second argument is the path to mount this directory to within the container. For more information on this topic, see `Bind Paths and Mounts in the Singularity documentation <https://singularity.hpcng.org/user-docs/master/bind_paths_and_mounts.html>`_.


Use GPUs with your container
==============================
Singularity supports deploying containers that use Nvidia's CUDA or AMD's ROCm solutions. Currently, on Google Cloud, and by extension the RCC, only Nvidia GPU's are available. If you've configured a compute partition to have GPU's attached, you can easily expose a GPU and the host system's drivers to the container using the :code:`--nv` flag.

The example below shows how to deploy a Singularity container image with GPU support.

.. code-block:: shell

    singularity --nv exec --bind /path/to/host/directory:/path/to/container/mount ${HOME}/IMAGE-NAME.sif

In order to use the :code:`--nv` flag, you need to make sure the following conditions are met

* Your application is built in your container using a CUDA version that matches the RCC's CUDA version ( 11.4.2 )
* Your application is built in your container to target a GPU with the appropriate device capability.


The latter requirement is met by using the appropriate compiler flag with :code:`nvcc` or :code:`GPU_TARGET` environment variable with :code:`hipcc` or :code:`hipfc`.

When building applications with :code:`nvcc`, use the :code:`-arch=sm_XX` flag (replacing :code:`XX` with the appropriate device capability). A table of the GPU models and corresponding device capabilities is given below.

.. list-table:: GPU Device Capabilities
   :widths: 25 25
   :header-rows: 1

   * - GPU Model
     - Device Capability
   * - Nvidia Tesla K80 (Kepler)
     - sm_30, sm_35, sm_37
   * - Nvidia Tesla P100 (Pascal)
     - sm_60, sm_61, sm_62
   * - Nvidia Tesla P4 (Pascal)
     - sm_60, sm_61, sm_62
   * - Nvidia Tesla T4 (Turing)
     - sm_75
   * - Nvidia Tesla V100 (Volta)
     - sm_70, sm_72
   * - Nvidia Tesla A100 (Ampere)
     - sm_80, sm_86


Further Reading
================

* `Singularity Documentation <https://singularity.hpcng.org/user-docs/master/>`_
* `Using GPUs with Singularity Containers <https://singularity.hpcng.org/user-docs/master/gpu.html>`_
* `Using MPI with Singularity Containers <https://singularity.hpcng.org/user-docs/master/mpi.html>`_
