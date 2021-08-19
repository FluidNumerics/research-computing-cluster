#!/bin/bash
#
#
# Maintainers : @schoonovernumerics
#
# //////////////////////////////////////////////////////////////// #


source ${INSTALL_ROOT}/spack/share/spack/setup-env.sh

# Set up AMD Clang compilers (provided by ROCm)
spack compiler rm clang # Remove existing clang compiler
cat << EOF >>  ${INSTALL_ROOT}/spack/etc/spack/compilers.yaml
- compiler:
    spec: clang@13.0.0
    paths:
      cc: /opt/rocm/bin/amdclang
      cxx: /opt/rocm/bin/amdclang++
      f77: /opt/rocm/bin/amdflang
      fc: /opt/rocm/bin/amdflang
    flags: {}
    operating_system: centos7
    target: x86_64
    modules: []
    environment: {}
    extra_rpaths: []
EOF

## Install "after-market" GNU compiler
COMPILERS=("gcc@10.2.0"
           "gcc@9.4.0"
	   "intel-oneapi-compilers@2021.3.0")

for COMPILER in "${COMPILERS[@]}"; do
  spack install ${COMPILER} % gcc@4.8.5 target=${ARCH}
done

# Install OpenMPI with desired compilers
COMPILERS=("gcc@10.2.0"
           "gcc@9.4.0"
           "clang"
	   "intel")
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
