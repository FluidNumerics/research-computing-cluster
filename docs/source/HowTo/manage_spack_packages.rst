############################
Manage Packages with Spack
############################


Using Installed Packages
#########################
Packages on RCC clusters are installed by Spack and are exposed to users through the :code:`spack` command line interface. The RCC comes with a preconfigured sitewide :code:`packages.yaml` and :code:`compilers.yaml`. For convenience, the RCC comes with Singularity (3.7.4), a suite of compilers, and corresponding builds of OpenMPI (4.0.2). All of these packages are managed via Spack. 

Listing Packages
To show what packages are currently available on the cluster, you can use the :code: `spack find`.

.. code-block:: shell

   $ spack find


Loading and Unloading Packages
-------------------------------
To load packages that have been previously installed by spack, you can use the :code:`spack load` command.

For example, to load OpenMPI compiled with the :code:`gcc@10.2.0` compiler, you can use the command

.. code-block:: shell

   spack load gcc@10.2.0 openmpi@4.0.2 % gcc@10.2.0

If you want to remove a package from your path, you can use :code:`spack unload` command.

For example, to unload OpenMPI, you can use the command

.. code-block:: shell

   spack unload openmpi@4.0.2 % gcc@10.2.0

Install Additional Packages with Spack
#########################################
For the RCC, we highly recommend following a "build,test,deploy" model for operations. This process involves baking a VM image that has your desired applications installed, using one of the RCC images as a base. As part of the build process, you can test a deployment with your applications installed using `fluid-run <https://github.com/fluidnumerics/fluid-run>`_. Upon passing tests, you can then deploy using the `RCC-tf module <https://github.com/fluidnumerics/rcc-tf>`_. Occasionally, too, you may find yourself in a situation where you want to install packages on-the-fly on your cluster. For either scenario, Spack supports the installation of a large number of packages from source, which gives you the ability to control compilation flags and the types of features to include with each packages build.

Use the checklist below to help guide package installation with spack.


1. First check that the desired package can be built with spack using the spack list command. Alternatively, you can visit the spack packages list page to see if the desired package is supported.

2. Use the spack info command to familiarize yourself with the packages dependencies, available versions, and available build specs.

3. Preview what packages will be installed by using spack spec. Keep in mind that you can specify the package version and the compiler to build with. Additionally, you can concretize the package variants to customize the installation. For example, some packages like hdf5 can be built with or without mpi support. The example below will provide a spec for hdf5@1.10.7 using the provided gcc@10.2 and openmpi@4.0.2 packages. This eliminates the need for spack to install additional dependencies.


spack spec hdf5@1.10.7 % gcc@10.2 +cxx+fortran+mpi+threadsafe^openmpi@4.0.2

Input spec

--------------------------------

hdf5

Concretized

--------------------------------

hdf5@1.10.7%gcc@10.2+cxx~debug+fortran~hl~java+mpi+pic+shared~szip+threadsafe api=none arch=linux-debian10-haswell

Install the package using the spack install command.
Since packages are installed from source, some packages may take a while to build. As an example, to install hdf5@1.10.7 using the provided gcc@10.2 and openmpi@4.0.2 packages,

spack install hdf5@1.10.7 % gcc@10.2 +cxx+fortran+mpi+threadsafe^openmpi@4.0.2
