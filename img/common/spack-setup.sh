#!/bin/bash
#
#
# Maintainers : @schoonovernumerics
#
# //////////////////////////////////////////////////////////////// #


######################################################################################################################

## Install spack
git clone https://github.com/FluidNumerics/spack.git ${INSTALL_ROOT}/spack

echo "#!/bin/bash" > /etc/profile.d/z10_spack_environment.sh
echo "export SPACK_ROOT=${INSTALL_ROOT}/spack" >> /etc/profile.d/z10_spack_environment.sh
echo ". \${SPACK_ROOT}/share/spack/setup-env.sh" >> /etc/profile.d/z10_spack_environment.sh

source ${INSTALL_ROOT}/spack/share/spack/setup-env.sh
# Adjust config so that spack install paths are padded to allow for relocation
#spack config add "config:install_tree:padded_length:128"

if [[ -f "/tmp/packages.yaml" ]]; then
  mv /tmp/packages.yaml ${INSTALL_ROOT}/spack/etc/spack/packages.yaml
fi

# Find system compilers
spack compiler find --scope site

## For ensuring that Slurm paths are in default path ##
if [[ -f "/etc/profile.d/slurm.sh" ]]; then
	mv /etc/profile.d/slurm.sh /etc/profile.d/z11_slurm.sh
fi

if [[ -f "/etc/profile.d/cuda.sh" ]]; then
	mv /etc/profile.d/cuda.sh /etc/profile.d/z11_cuda.sh
fi


# Add spack mirror #
spack gpg init
spack mirror add RCC gs://rcc-spack-cache
spack gpg create ${INSTALL_ROOT}/spack/share/RCC_gpg support@fluidnumerics.com
#spack buildcache keys --install --trust
# ---------------- #
