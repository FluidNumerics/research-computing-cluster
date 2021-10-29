#!/bin/bash


function cluster_services_setup(){

    mkdir -p /apps/cls/build
    mkdir -p /apps/cls/bin
    mkdir -p /apps/cls/etc
    mkdir -p /apps/cls/log
    
    cp /tmp/cluster-services/src/cluster-config.schema.json /apps/cls/etc/
    cp /tmp/cluster-services/src/cluster_services.py /apps/cls/build/
    
    # Compile cluster-services to a binary
    /usr/local/bin/cython --embed -o /apps/cls/build/cluster_services.c /apps/cls/build/cluster_services.py
    gcc -O2 -I /usr/include/python3.8/ -o /apps/cls/bin/cluster-services /apps/cls/build/cluster_services.c  -L/usr/lib/x86_64-linux-gnu/ -lpython3.8 -lpthread -lm -lutil -ldl

    rm -r /apps/cls/build
    
    chmod 700 /apps/cls/bin/cluster-services
    
    echo "#!/bin/bash" > /etc/profile.d/z11_cls.sh
    echo "export PATH=\${PATH}:/apps/cls/bin" >> /etc/profile.d/z11_cls.sh
}

function rocm_setup(){
    wget -q -O - https://repo.radeon.com/rocm/rocm.gpg.key | sudo apt-key add -
    echo 'deb [arch=amd64] https://repo.radeon.com/rocm/apt/debian/ ubuntu main' | sudo tee /etc/apt/sources.list.d/rocm.list
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

cluster_services_setup

rocm_setup

if [[ -n "$SPACK_BUCKET" ]]; then
    spack mirror rm RCC
fi

cat /dev/null > /var/log/syslog
