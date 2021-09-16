#!/bin/bash


function system_deps(){

    export DEBIAN_FRONTEND=noninteractive
    rm /var/lib/dpkg/lock
    rm /var/lib/apt/lists/lock
    rm /var/cache/apt/archives/lock
    dpkg  --configure -a
    apt-get update -y 
    apt-get install -y libnuma-dev python3-dev python3-pip build-essential zip unzip
    pip3 install --upgrade google-cloud-storage google-api-python-client oauth2client google-cloud \
    	               cython pyyaml parse docopt jsonschema dictdiffer
}

function cluster_services_setup(){

    gcloud source repos clone cluster-services --project=fluid-cluster-ops /tmp/cluster-services

    mkdir -p ${INSTALL_ROOT}/cls/build
    mkdir -p ${INSTALL_ROOT}/cls/bin
    mkdir -p ${INSTALL_ROOT}/cls/etc
    mkdir -p ${INSTALL_ROOT}/cls/log
    
    cp /tmp/cluster-services/src/cluster-config.schema.json ${INSTALL_ROOT}/cls/etc/
    cp /tmp/cluster-services/src/cluster_services.py ${INSTALL_ROOT}/cls/build/
    
    # Compile cluster-services to a binary
    /usr/local/bin/cython --embed -o ${INSTALL_ROOT}/cls/build/cluster_services.c ${INSTALL_ROOT}/cls/build/cluster_services.py
    gcc -O2 -I /usr/include/python3.7m/ -o ${INSTALL_ROOT}/cls/bin/cluster-services ${INSTALL_ROOT}/cls/build/cluster_services.c  -L/usr/lib/x86_64-linux-gnu/ -lpython3.7m -lpthread -lm -lutil -ldl

    rm -r ${INSTALL_ROOT}/cls/build
    
    
    chmod 700 ${INSTALL_ROOT}/cls/bin/cluster-services
    
    ln -s /slurm/scripts/config.yaml ${INSTALL_ROOT}/cls/etc/config.yaml
    
    echo "#!/bin/bash" > /etc/profile.d/z11_cls.sh
    echo "export PATH=\${PATH}:${INSTALL_ROOT}/cls/bin" >> /etc/profile.d/z11_cls.sh
}

function rocm_setup(){
    wget -q -O - https://repo.radeon.com/rocm/rocm.gpg.key | sudo apt-key add -
    echo 'deb [arch=amd64] https://repo.radeon.com/rocm/apt/4.2/ xenial main' | sudo tee /etc/apt/sources.list.d/rocm.list
    apt-get update -y
    apt-get install -y rocm-dev
    
    echo 'ADD_EXTRA_GROUPS=1' | sudo tee -a /etc/adduser.conf
    echo 'EXTRA_GROUPS=video' | sudo tee -a /etc/adduser.conf
    
    cat > /etc/profile.d/z11-rocm.sh << EOL
#!/bin/bash

export PATH=\${PATH}:/opt/rocm/bin
export LD_LIBRARY_PATH=\${LD_LIBRARY_PATH}:/opt/rocm/lib
export HIP_PLATFORM=nvcc

EOL
}

system_deps

cluster_services_setup

#rocm_setup
