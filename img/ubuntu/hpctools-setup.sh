#!/bin/bash
#
#
# Maintainers : @schoonovernumerics
#
# //////////////////////////////////////////////////////////////// #


source ${INSTALL_ROOT}/spack/share/spack/setup-env.sh


# Checkpoint/Restart tools
spack install dmtcp target=${ARCH}

# Profilers
spack install hpctoolkit@2021.05.15 +cuda~viewer target=${ARCH}  # HPC Toolkit requires gcc 7 or above

spack gc -y
spack module lmod refresh --delete-tree -y


# Benchmarks
#
#   hpcc - installs HPL, DGEMM, STREAM
#
spack install hpcc target=x86_64
spack install hpcc target=cascadelake
spack install hpcc target=zen3

spack install hpcg target=x86_64
spack install hpcg target=cascadelake
spack install hpcg target=zen3

spack install osu-micro-benchmarks target=x86_64
