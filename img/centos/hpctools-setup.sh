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
spack install hpctoolkit@2021.05.15 +cuda~viewer % gcc@10.3.0 target=${ARCH}  # HPC Toolkit requires gcc 7 or above
spack install intel-oneapi-vtune@2021.6.0 % gcc@4.8.5 target=${ARCH}

spack gc -y
spack module lmod refresh --delete-tree -y




