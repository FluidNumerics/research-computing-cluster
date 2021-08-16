#!/bin/bash


source/etc/profile.d/z10_spack_environment.sh
spack install dmtcp target=${ARCH}

# TO DO : Add example dmtcp template for recovering job under preemption
