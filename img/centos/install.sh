#!/bin/bash

spack_install() {
  # This function attempts to install from the cache. If this fails, 
  # then it will install from source and create a buildcache for this package
  source /etc/profile.d/z10_spack_environment.sh 
  if [[ -n "$SPACK_BUCKET" ]]; then
    spack buildcache install "$1" || \
  	  ( spack install --no-cache "$1" && \
  	    spack buildcache create -a --rebuild-index \
  	                            -k ${INSTALL_ROOT}/spack/share/RCC_gpg \
				    -m RCC \
				    -f "$1" )
  else
     spack install "$1"
  fi
}

function cluster_services_setup(){

    mkdir -p ${INSTALL_ROOT}/cls/build
    mkdir -p ${INSTALL_ROOT}/cls/bin
    mkdir -p ${INSTALL_ROOT}/cls/etc
    mkdir -p ${INSTALL_ROOT}/cls/log
    
    cp /tmp/cluster-services/src/cluster-config.schema.json ${INSTALL_ROOT}/cls/etc/
    cp /tmp/cluster-services/src/cluster_services.py ${INSTALL_ROOT}/cls/build/
    
    # Compile cluster-services to a binary
    /usr/local/bin/cython --embed -o ${INSTALL_ROOT}/cls/build/cluster_services.c ${INSTALL_ROOT}/cls/build/cluster_services.py
    gcc -O2 -I /usr/include/python3.6m/ -o ${INSTALL_ROOT}/cls/bin/cluster-services ${INSTALL_ROOT}/cls/build/cluster_services.c  -L/usr/lib64/ -lpython3.6m -lpthread -lm -lutil -ldl
    
    rm -r ${INSTALL_ROOT}/cls/build
    
    chmod 700 ${INSTALL_ROOT}/cls/bin/cluster-services
    
    echo "#!/bin/bash" > /etc/profile.d/z11_cls.sh
    echo "export PATH=\${PATH}:${INSTALL_ROOT}/cls/bin" >> /etc/profile.d/z11_cls.sh
}

cluster_services_setup

# Checkpoint/Restart tools
spack_install "dmtcp % gcc@4.8.5 target=${ARCH}"

# Profilers
spack_install "hpctoolkit@2021.05.15 +cuda~viewer % gcc@10.3.0 target=${ARCH}"  # HPC Toolkit requires gcc 7 or above
#spack_install "intel-oneapi-vtune@2021.6.0 % gcc@4.8.5 target=${ARCH}"

spack gc -y

if [[ -n "$SPACK_BUCKET" ]]; then
    spack mirror rm RCC
fi

cat /dev/null > /var/log/messages
