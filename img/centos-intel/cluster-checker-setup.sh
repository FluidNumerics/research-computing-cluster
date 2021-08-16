#!/bin/bash


tee > /etc/yum.repos.d/oneAPI.repo << EOF
[oneAPI]
name=Intel® oneAPI repository
baseurl=https://yum.repos.intel.com/oneapi
enabled=1
gpgcheck=1
repo_gpgcheck=1
gpgkey=https://yum.repos.intel.com/intel-gpg-keys/GPG-PUB-KEY-INTEL-SW-PRODUCTS-23.PUB
EOF

repoquery --repofrompath=reponame,https://yum.repos.intel.com/oneapi --repoid=reponame -a | grep clck

yum update -y
yum install -y intel-oneapi-clck-2021.1.1-68
