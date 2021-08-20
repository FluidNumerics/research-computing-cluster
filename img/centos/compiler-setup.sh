#!/bin/bash
#
#
# Maintainers : @schoonovernumerics
#
# //////////////////////////////////////////////////////////////// #


source ${INSTALL_ROOT}/spack/share/spack/setup-env.sh


# Install "after-market" compilers
COMPILERS=("gcc@10.2.0"
           "gcc@9.4.0"
	   "intel-oneapi-compilers@2021.3.0")

for COMPILER in "${COMPILERS[@]}"; do
  spack install ${COMPILER} % gcc@4.8.5 target=${ARCH}
  spack load ${COMPILER} && spack compiler find --scope site && spack unload ${COMPILER}
done

spack compiler find --scope site
# Adjust the paths to AMD Clang/Flang compilers
sed -i "s#cc: /bin/clang-ocl#cc: /opt/rocm/bin/amdclang#" ${INSTALL_ROOT}/spack/etc/spack/compilers.yaml
sed -i "s#cxx: null#cxx: /opt/rocm/bin/amdclang++#" ${INSTALL_ROOT}/spack/etc/spack/compilers.yaml
sed -i "s#f77: null#f77: /opt/rocm/bin/amdflang#" ${INSTALL_ROOT}/spack/etc/spack/compilers.yaml
sed -i "s#fc: null#fc: /opt/rocm/bin/amdflang#" ${INSTALL_ROOT}/spack/etc/spack/compilers.yaml
cat ${INSTALL_ROOT}/spack/etc/spack/compilers.yaml

# Install OpenMPI with desired compilers
COMPILERS=("gcc@10.2.0"
           "gcc@9.4.0"
           "clang@13.0.0"
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
