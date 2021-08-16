#!/bin/bash
#
#
# Maintainers : @schoonovernumerics
#
# //////////////////////////////////////////////////////////////// #


source ${INSTALL_ROOT}/spack/share/spack/setup-env.sh

# Install singularity
spack install singularity target=${ARCH}

COMPILERS=("intel-oneapi-compilers"
           "gcc@10.2.0"
	   "gcc@9.4.0"
	   "gcc@8.5.0"
	   "gcc@7.5.0")

## Install "after-market" compiler
for COMPILER in "${COMPILERS[@]}"; do
  spack install ${COMPILER} % gcc@4.8.5 target=${ARCH}
done

for COMPILER in "${COMPILERS[@]}"; do
  spack load ${COMPILER} && spack compiler find --scope site && spack unload ${COMPILER}
  if [[ "$COMPILER" == *"intel"* ]];then
    spack install openmpi@4.0.5 % intel target=${ARCH}
  else
    spack install openmpi@4.0.5 % ${COMPILER} target=${ARCH}
  fi
done

spack gc -y
spack module lmod refresh --delete-tree -y
