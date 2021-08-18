#!/bin/bash
#
#
# Maintainers : @schoonovernumerics
#
# //////////////////////////////////////////////////////////////// #


source ${INSTALL_ROOT}/spack/share/spack/setup-env.sh

COMPILERS=("aocc@3.1.0 +license-agreed"
	   "aomp@3.10.0"
           "gcc@10.2.0")

## Install "after-market" compiler
for COMPILER in "${COMPILERS[@]}"; do
  spack install ${COMPILER} % gcc@4.8.5 target=${ARCH}
done

for COMPILER in "${COMPILERS[@]}"; do
  spack load ${COMPILER} && spack compiler find --scope site && spack unload ${COMPILER}
  if [[ "$COMPILER" == *"intel"* ]];then
    spack install openmpi@4.0.5 % intel target=${ARCH}
  elif [[ "$COMPILER" == *"aocc"* ]];then
    spack install openmpi@4.0.5 % aocc target=${ARCH}
  else
    spack install openmpi@4.0.5 % ${COMPILER} target=${ARCH}
  fi
done

spack gc -y
spack module lmod refresh --delete-tree -y
