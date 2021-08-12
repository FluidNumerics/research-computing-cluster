#!/bin/bash
#
#
# Maintainers : @schoonovernumerics
#
# //////////////////////////////////////////////////////////////// #


source ${INSTALL_ROOT}/spack/share/spack/setup-env.sh

# Install singularity
spack install singularity % gcc@4.8.5 target=${ARCH}
spack install dmtcp % gcc@4.8.5 target=${ARCH}

COMPILERS=("intel-oneapi-compilers"
           "gcc@10.2.0"
	   "gcc@9.4.0"
	   "gcc@8.5.0"
	   "gcc@7.5.0")

## Install "after-market" compiler
for COMPILER in "${COMPILERS[@]}"; do
  spack install ${COMPILER} % gcc@4.8.5 target=${ARCH}
  spack load ${COMPILER} && spack compiler find --scope site && spack unload ${COMPILER}
  if [[ "$COMPILER" == *"intel"* ]];then
    spack install openmpi@4.0.5 % intel target=${ARCH}
  else
    spack install openmpi@4.0.5 % ${COMPILER} target=${ARCH}
  fi
done
spack gc -y
spack module lmod refresh --delete-tree -y

# Update MOTD
cat > /etc/motd << EOL
=======================================================================  
  Fluid HPC Base VM Image
  Copyright 2021 Fluid Numerics LLC
=======================================================================  

  This solution contains free and open-source software 
  All applications installed can be listed using 

  module spider

  You can obtain the source code and licenses for any 
  installed application using the following command :

  ls \$(spack location -i pkg)/share/pkg/src

  replacing "pkg" with the name of the package.

=======================================================================  

  To get started, check out the included docs

    cat ${INSTALL_ROOT}/share/doc

EOL
