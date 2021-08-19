#!/bin/bash
#
#
# Maintainers : @schoonovernumerics
#
# //////////////////////////////////////////////////////////////// #


source ${INSTALL_ROOT}/spack/share/spack/setup-env.sh


# Checkpoint/Restart tools
spack install dmtcp % gcc@4.8.5 target=${ARCH}

# Profilers
spack install hpctoolkit@2021.05.15 +cuda~viewer % gcc@10.2.0 target=${ARCH}  # HPC Toolkit requires gcc 7 or above
spack install intel-oneapi-vtune@2021.6.0 % gcc@4.8.5 target=${ARCH}

spack gc -y
spack module lmod refresh --delete-tree -y


# Benchmarks
#
#   hpcc - installs HPL, DGEMM, STREAM
#
COMPILERS=("gcc@10.2.0"
           "gcc@9.4.0"
           "clang"
	   "intel")
for COMPILER in "${COMPILERS[@]}"; do
  spack install hpcc % ${COMPILER} target=x86_64
  spack install hpcc % ${COMPILER} target=cascadelake
  spack install hpcc % ${COMPILER} target=zen3

  spack install hpcg % ${COMPILER} target=x86_64
  spack install hpcg % ${COMPILER} target=cascadelake
  spack install hpcg % ${COMPILER} target=zen3

  spack install osu-micro-benchmarks % ${COMPILER} target=x86_64

done

