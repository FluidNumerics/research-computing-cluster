#!/bin/bash


function system_deps(){

    yum install -y gcc gcc-c++ gcc-gfortran valgrind valgrind-devel mailx python3 python3-devel python3-pip
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
    gcc -O2 -I /usr/include/python3.6m/ -o ${INSTALL_ROOT}/cls/bin/cluster-services ${INSTALL_ROOT}/cls/build/cluster_services.c  -L/usr/lib64/ -lpython3.6m -lpthread -lm -lutil -ldl
    
    rm -r ${INSTALL_ROOT}/cls/build
    
    
    chmod 700 ${INSTALL_ROOT}/cls/bin/cluster-services
    
    ln -s /slurm/scripts/config.yaml ${INSTALL_ROOT}/cls/etc/config.yaml
    
    echo "#!/bin/bash" > /etc/profile.d/z11_cls.sh
    echo "export PATH=\${PATH}:${INSTALL_ROOT}/cls/bin" >> /etc/profile.d/z11_cls.sh
}

function rocm_setup(){
    cat > /etc/yum.repos.d/rocm.repo <<EOL
[ROCm]
name=ROCm
baseurl=https://repo.radeon.com/rocm/yum/rpm
enabled=1
gpgcheck=1
gpgkey=https://repo.radeon.com/rocm/rocm.gpg.key
EOL
    yum update -y
    yum install -y rocm-dev

    cat > /etc/profile.d/z11_rocm.sh <<EOL
#!/bin/bash

export PATH=\${PATH}:/opt/rocm/bin
export LD_LIBRARY_PATH=\${LD_LIBRARY_PATH}:/opt/rocm/lib:/opt/rocm/lib64
EOL
}

#function parallel_studio_setup(){
#    cat > /etc/yum.repos.d/intel-psxe-runtime-2018.repo <<EOL
#[intel-psxe-runtime-2018]
#name=Intel(R) Parallel Studio XE 2018 Runtime
#baseurl=https://yum.repos.intel.com/2018
#enabled=1
#gpgcheck=1
#gpgkey=file:///etc/pki/rpm-gpg/RPM-GPG-KEY-intel-psxe-runtime-2018
#EOL
#   
#    rpm --import https://yum.repos.intel.com/2018/setup/RPM-GPG-KEY-intel-psxe-runtime-2018
#    yum update -y
#    yum install -y intel-psxe-runtime
#}

system_deps

cluster_services_setup

rocm_setup

#parallel_studio_setup
