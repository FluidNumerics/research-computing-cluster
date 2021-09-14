#!/bin/bash
#
#
# Maintainers : @schoonovernumerics
#
# //////////////////////////////////////////////////////////////// #

spack_install() {
  # This function attempts to install from the cache. If this fails, 
  # then it will install from source and create a buildcache for this package
  spack buildcache install "$1" || \
	  ( spack install --no-cache "$1" && \
	  spack buildcache create -a --rebuild-index \
	                          -k ${INSTALL_ROOT}/spack/share/RCC_gpg \
				  -m RCC "$1" )
}

source ${INSTALL_ROOT}/spack/share/spack/setup-env.sh


# Checkpoint/Restart tools
spack_install "dmtcp % gcc@4.8.5 target=${ARCH}"

# Profilers
spack_install "hpctoolkit@2021.05.15 +cuda~viewer % gcc@10.3.0 target=${ARCH}"  # HPC Toolkit requires gcc 7 or above
#spack_install "intel-oneapi-vtune@2021.6.0 % gcc@4.8.5 target=${ARCH}"

spack gc -y
