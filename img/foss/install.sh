#!/bin/bash


function system_deps(){

    yum install -y gcc gcc-c++ gcc-gfortran valgrind valgrind-devel mailx python3 python3-devel python3-pip
    pip3 install --upgrade google-cloud-storage google-api-python-client oauth2client google-cloud \
    	               cython pyyaml parse docopt jsonschema dictdiffer
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

system_deps

rocm_setup
