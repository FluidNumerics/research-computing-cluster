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

    mkdir -p /apps/cls/build
    mkdir -p /apps/cls/bin
    mkdir -p /apps/cls/etc
    mkdir -p /apps/cls/log
    
    cp /tmp/cluster-services/src/cluster-config.schema.json /apps/cls/etc/
    cp /tmp/cluster-services/src/cluster_services.py /apps/cls/build/
    
    # Compile cluster-services to a binary
    /usr/local/bin/cython --embed -o /apps/cls/build/cluster_services.c /apps/cls/build/cluster_services.py
    gcc -O2 -I /usr/include/python3.6m/ -o /apps/cls/bin/cluster-services /apps/cls/build/cluster_services.c  -L/usr/lib64/ -lpython3.6m -lpthread -lm -lutil -ldl
    
    rm -r /apps/cls/build
    
    chmod 700 /apps/cls/bin/cluster-services
    
    echo "#!/bin/bash" > /etc/profile.d/z11_cls.sh
    echo "export PATH=\${PATH}:/apps/cls/bin" >> /etc/profile.d/z11_cls.sh
}

cluster_services_setup

if [[ -n "$SPACK_BUCKET" ]]; then
    spack mirror rm RCC
fi

cat /dev/null > /var/log/messages
