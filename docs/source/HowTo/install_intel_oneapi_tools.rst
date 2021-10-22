===========================
Install Intel OneAPI Tools
===========================

`The Intel® OneAPI HPC Toolkit <https://www.intel.com/content/www/us/en/developer/tools/oneapi/hpc-toolkit.html>`_ comes with Intel® compilers, MPI, Inspector, Cluster Checker, and Trace Analyzer and Collector. Most of these tools can be easily installed on your cluster using :code:`spack`.

.. code-block:: shell

    spack install intel-oneapi-advisor intel-oneapi-compilers intel-oneapi-inspector intel-oneapi-mkl intel-oneapi-mpi intel-oneapi-vtune intel-oneapi-tbb


Once installed, these packages can be added to any users environment on your cluster using the :code:`spack load` command.

