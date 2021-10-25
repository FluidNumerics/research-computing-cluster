==============================
Customize User Environment
==============================

The Research Computing Cluster uses `Spack <https://spack.io>` to install and manage packages, including compilers, MPI builds, and other packages. When you log into the cluster the system provided compilers and the `AOMP <https://github.com/ROCm-Developer-Tools/aomp>`_ compilers are in your default path. You can use :code:`spack` commands to install new packages, create custom environments within your own user space, and load/unload packages provided in the RCC.

Install Packages with Spack (User environments)
================================================
`Spack currently has over 5000 packages <https://spack.readthedocs.io/en/latest/package_list.html>`_ that can be installed via :code:`spack`. 

Since spack's install directory is not NFS mounted across the cluster (:code:`/opt`), we highly recommend using a `Spack environment <https://spack.readthedocs.io/en/latest/environments.html>`_. Creating a Spack environment in your home directory, which is NFS mounted, will allow those packages to be exposed to other instances in your cluster.

You can create a new environment in your home directory using

.. code-block:: shell

    $ mkdir ${HOME}/env
    $ spack env create -d ${HOME}/env
    ==> Updating view at /home/joe/env/.spack-env/view
    ==> Created environment in /home/joe/env
    ==> You can activate this environment with:
    ==>   spack env activate /home/joe/env

Once created, you can active the environment

.. code-block:: shell

    $ spack env activate ${HOME}/env


Once activated, you can install packages into your environment while using packages included with the RCC images as dependencies. 

Packages are installed using :code:`spack install` commands. You can `read more about installing packages with Spack in the basic usage documentation <https://spack.readthedocs.io/en/latest/basic_usage.html#installing-and-uninstalling>`_.

To learn more about Spack environments, we highly recommend you walk through the `Spack Environments Tutorial <https://spack-tutorial.readthedocs.io/en/latest/tutorial_environments.html>`_.



Install Packages with Spack (Image Baking)
============================================
If you are an administrator of an RCC, or you are self-administrating, you can also build packages on top of the RCC images. With this approach, packages are installed under the :code:`/opt` directory on VM images and you deploy the cluster using this new image.

For more information on baking images for your applications,see the `RCC Apps documentation <https://rcc-apps.readthedocs.io>`_.
