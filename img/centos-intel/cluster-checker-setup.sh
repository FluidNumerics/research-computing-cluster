#!/bin/bash


tee > /etc/yum.repos.d/oneAPI.repo << EOF
[oneAPI]
name=Intel(R) oneAPI repository
baseurl=https://yum.repos.intel.com/oneapi
enabled=1
gpgcheck=1
repo_gpgcheck=1
gpgkey=https://yum.repos.intel.com/intel-gpg-keys/GPG-PUB-KEY-INTEL-SW-PRODUCTS-2023.PUB
EOF

repoquery --repofrompath=reponame,https://yum.repos.intel.com/oneapi --repoid=reponame -a | grep clck

yum update -y
yum install -y intel-oneapi-clck
