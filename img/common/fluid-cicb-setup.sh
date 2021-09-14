#!/bin/bash

spack_install() {
  # This function attempts to install from the cache. If this fails, 
  # then it will install from source and create a buildcache for this package
  spack buildcache install "$1" || \
	  ( spack install --no-cache "$1" && \
	    spack buildcache create -a --rebuild-index \
	                            -k ${INSTALL_ROOT}/spack/share/RCC_gpg \
				    -m RCC "$1" )
}

source /etc/profile.d/z10_spack_environment.sh

mkdir -p /apps/workspace
chmod -R 777 /apps/workspace

# Install singularity
spack_install "singularity target=${ARCH}"
