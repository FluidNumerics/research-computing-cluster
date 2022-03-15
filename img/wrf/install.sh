#!/bin/bash

function cluster_services_setup(){

    mkdir -p /apps/cls/build
    mkdir -p /apps/cls/bin
    mkdir -p /apps/cls/etc
    mkdir -p /apps/cls/log
    
    yum install -y python3-devel

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

cat /dev/null > /var/log/messages
