#!/bin/bash


if [[ -n "$SPACK_BUCKET" ]]; then
        # Add spack mirror #
        spack gpg init
        spack gpg create ${INSTALL_ROOT}/spack/share/RCC_gpg support@fluidnumerics.com
        spack mirror add RCC ${SPACK_BUCKET}
        spack buildcache keys --install --trust
fi

