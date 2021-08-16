#!/bin/bash

source /etc/profile.d/z10_spack_environment.sh

mkdir -p /apps/workspace
chmod -R 777 /apps/workspace

# Install singularity
spack install singularity target=${ARCH}
