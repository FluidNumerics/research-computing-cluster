#!/bin/bash
#
#
# Maintainers : @schoonovernumerics
#
# //////////////////////////////////////////////////////////////// #


source ${INSTALL_ROOT}/spack/share/spack/setup-env.sh

# Set up AMD Clang compilers (provided by ROCm)
spack compiler rm clang # Remove existing clang compiler

# Adjust the paths to AMD Clang/Flang compilers
sed -i "s#cc: /usr/bin/clang-ocl#cc: /opt/rocm/bin/amdclang#" ${INSTALL_ROOT}/spack/etc/spack/compilers.yaml
sed -i "s#cxx: None#cxx: /opt/rocm/bin/amdclang++#" ${INSTALL_ROOT}/spack/etc/spack/compilers.yaml
sed -i "s#f77: None#f77: /opt/rocm/bin/amdflang#" ${INSTALL_ROOT}/spack/etc/spack/compilers.yaml
sed -i "s#fc: None#fc: /opt/rocm/bin/amdflang#" ${INSTALL_ROOT}/spack/etc/spack/compilers.yaml

## Install "after-market" GNU compiler
COMPILERS=("gcc@10.2.0"
           "gcc@9.4.0"
	   "intel-oneapi-compilers@2021.3.0")

for COMPILER in "${COMPILERS[@]}"; do
  spack install ${COMPILER} % gcc@4.8.5 target=${ARCH}
  spack load ${COMPILER} && spack compiler find --scope site && spack unload ${COMPILER}
done

# Install OpenMPI with desired compilers
COMPILERS=("gcc@10.2.0"
           "gcc@9.4.0"
           "clang"
	   "intel")
for COMPILER in "${COMPILERS[@]}"; do
  if [[ "$COMPILER" == *"intel"* ]];then
    spack install openmpi@4.0.5 % intel target=${ARCH}
  else
    spack install openmpi@4.0.5 % ${COMPILER} target=${ARCH}
  fi
done

spack gc -y
spack module lmod refresh --delete-tree -y
