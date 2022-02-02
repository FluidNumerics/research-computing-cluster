############################
Manage Packages with Spack
############################


Using Installed Packages
#########################
The Research Computing Cluster uses `Spack <https://spack.io>` to install and manage packages, including compilers, MPI builds, and other packages. When you log into the cluster the system provided compilers and the `AOMP <https://github.com/ROCm-Developer-Tools/aomp>`_ compilers are in your default path. You can use :code:`spack` commands to install new packages, create custom environments within your own user space, and load/unload packages provided in the RCC.

Listing Packages
-----------------
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

Install packages with spack
#########################################
On the RCC, spack is installed in a directory is not NFS mounted across the cluster (:code:`/opt`). Because of this, running :code:`spack install` commands will only install packages on the instance that you run the command on. Because of this, it is best practice to :ref:`Install packages using spack environments`. However, you may find it helpful to test package installations. Use the checklist below to help guide package installation with spack.


1. First check that the desired package can be built with spack using the :code:`spack list` command. Alternatively, you can visit the `spack packages list <https://spack.readthedocs.io/en/latest/package_list.html>`_ page to see if the desired package is supported.

2. Use the :code:`spack info` command to familiarize yourself with the packages dependencies, available versions, and available build specs.

3. Preview what packages will be installed by using :code:`spack spec`. Keep in mind that you can specify the package version and the compiler to build with. Additionally, you can concretize the package variants to customize the installation. For example, some packages like hdf5 can be built with or without mpi support. 

4. Consider the target architecture that you want to run on. On Google Cloud, you have access to haswell/broadwell (n1 & e2 instances), cascadelake (a2, c2, & n2 instances), zen3 (n2d), and zen4 (c2d) instances. For many applications, specifying the target architecture instructs the compiler to leverage architecture specific optimizations. Often, this can improve application performance and consequently reduce runtime costs.

5. Install the package using the :Code:`spack install` command. Since packages are installed from source, some packages may take a while to build. 

Install packages using spack environments
###########################################
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
For the RCC, we highly recommend following a "build,test,deploy" model for operations. This process involves baking a VM image that has your desired applications installed, using one of the RCC images as a base. As part of the build process, you can test a deployment with your applications installed using `fluid-run <https://github.com/fluidnumerics/fluid-run>`_. Upon passing tests, you can then deploy using the `RCC-tf module <https://github.com/fluidnumerics/rcc-tf>`_. Occasionally, too, you may find yourself in a situation where you want to install packages on-the-fly on your cluster. For either scenario, Spack supports the installation of a large number of packages from source, which gives you the ability to control compilation flags and the types of features to include with each packages build.

If you are an administrator of an RCC, or you are self-administrating, you can also build packages on top of the RCC images. With this approach, packages are installed under the :code:`/opt` directory on VM images and you deploy the cluster using this new image.

For more information on baking images for your applications,see the `RCC Apps documentation <https://rcc-apps.readthedocs.io>`_.

Loading Packages into your path
================================
Spack can be used to bring packages into your search path.

To list packages that are currently available, you can run :code:`spack find`

.. code-block:: shell

    $ spack find
    ==> 153 installed packages
    -- linux-centos7-broadwell / gcc@9.4.0 --------------------------
    berkeley-db@18.1.40  json-c@0.15           libunistring@0.9.10  readline@8.1
    bzip2@1.0.8          libaio@0.3.110        libxml2@2.9.12       shadow@4.8.1
    cryptsetup@2.3.5     libbsd@0.11.3         lvm2@2.03.05         singularity@3.7.4
    curl@7.78.0          libedit@3.1-20210216  ncurses@6.2          squashfs@4.4
    expat@2.4.1          libgpg-error@1.42     openssh@8.7p1        tar@1.26
    gdbm@1.19            libiconv@1.16         openssl@1.1.1l       util-linux@2.37.2
    gettext@0.21         libidn2@2.3.0         pcre2@10.36          util-linux-uuid@2.36.2
    git@2.31.1           libmd@1.0.3           perl@5.34.0          xz@5.2.5
    go@1.16.6            libseccomp@2.3.3      popt@1.16            zlib@1.2.11
    
    -- linux-centos7-x86_64 / clang@13.0.0 --------------------------
    hpcc@1.5.0            libpciaccess@0.16  openmpi@4.0.5               valgrind@3.15.0
    hwloc@2.5.0           libxml2@2.9.12     openssh@8.7p1               xz@5.2.5
    libedit@3.1-20210216  ncurses@6.2        openssl@1.1.1l              zlib@1.2.11
    libevent@2.0.21       numactl@2.0.14     osu-micro-benchmarks@5.7.1
    libiconv@1.16         openblas@0.3.17    slurm@20-11
    
    -- linux-centos7-x86_64 / gcc@4.8.5 -----------------------------
    dmtcp@2.6.0  gmp@6.2.1                  lua-luaposix@35.0  mpfr@4.1.0    unzip@6.0
    gcc@9.4.0    lmod@8.5.6                 mpc@1.1.0          ncurses@6.2   zlib@1.2.11
    gcc@10.3.0   lua@5.3.5                  mpc@1.1.0          readline@8.1  zstd@1.5.0
    gcc@11.2.0   lua-luafilesystem@1_7_0_2  mpfr@3.1.6         tcl@8.6.11
    
    -- linux-centos7-x86_64 / gcc@9.4.0 -----------------------------
    hpcc@1.5.0            libiconv@1.16      openblas@0.3.17             slurm@20-11
    hpcg@3.1              libpciaccess@0.16  openmpi@4.0.5               valgrind@3.15.0
    hwloc@2.5.0           libxml2@2.9.12     openssh@8.7p1               xz@5.2.5
    libedit@3.1-20210216  ncurses@6.2        openssl@1.1.1l              zlib@1.2.11
    libevent@2.0.21       numactl@2.0.14     osu-micro-benchmarks@5.7.1
    
    -- linux-centos7-x86_64 / gcc@10.3.0 ----------------------------
    binutils@2.37   hpctoolkit@2021.05.15  libunwind@1.5.0  osu-micro-benchmarks@5.7.1
    boost@1.76.0    hwloc@2.5.0            libxml2@2.9.12   papi@6.0.0.1
    bzip2@1.0.8     intel-tbb@2020.3       libxml2@2.9.12   slurm@20-11
    cuda@11.2.152   intel-xed@12.0.1       mbedtls@3.0.0    tar@1.26
    curl@7.78.0     libdwarf@20180129      memkind@1.10.1   valgrind@3.15.0
    dyninst@11.0.1  libedit@3.1-20210216   ncurses@6.2      xerces-c@3.2.3
    elfutils@0.185  libevent@2.0.21        numactl@2.0.14   xz@5.2.5
    gettext@0.21    libiberty@2.33.1       openblas@0.3.17  xz@5.2.5
    gotcha@1.0.3    libiconv@1.16          openmpi@4.0.5    zlib@1.2.11
    hpcc@1.5.0      libmonitor@2021.04.27  openssh@8.7p1
    hpcg@3.1        libpciaccess@0.16      openssl@1.1.1l
    
    -- linux-centos7-x86_64 / gcc@11.2.0 ----------------------------
    hpcc@1.5.0            libiconv@1.16      openblas@0.3.17             slurm@20-11
    hpcg@3.1              libpciaccess@0.16  openmpi@4.0.5               valgrind@3.15.0
    hwloc@2.5.0           libxml2@2.9.12     openssh@8.7p1               xz@5.2.5
    libedit@3.1-20210216  ncurses@6.2        openssl@1.1.1l              zlib@1.2.11
    libevent@2.0.21       numactl@2.0.14     osu-micro-benchmarks@5.7.1 

You can load a package, and all of its dependencies into your path using :code:`spack load`. 

.. code-block:: shell

    $ spack load openmpi % gcc@11.2.0

Since most packages are provided with builds associated with multiple compilers, you must specify the compiler using the :code:`% compiler` specifier after the package name.

To list packages that are currently loaded in your environment, use :code:`spack find --loaded`

.. code-block:: shell

    $ spack find --loaded
    -- linux-centos7-x86_64 / gcc@11.2.0 ----------------------------
    hwloc@2.5.0           libevent@2.0.21  libpciaccess@0.16  ncurses@6.2     openmpi@4.0.5  openssl@1.1.1l  valgrind@3.15.0  zlib@1.2.11
    libedit@3.1-20210216  libiconv@1.16    libxml2@2.9.12     numactl@2.0.14  openssh@8.7p1  slurm@20-11     xz@5.2.5

To unload a package from your path, use :code:`spack unload`

.. code-block:: shell

    $ spack unload openmpi % gcc@11.2.0


