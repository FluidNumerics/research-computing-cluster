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
