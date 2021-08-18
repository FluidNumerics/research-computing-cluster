#!/bin/bash


cat > /etc/yum.repos.d/intel-psxe-runtime-2018.repo <<EOL
[intel-psxe-runtime-2018]
name=Intel(R) Parallel Studio XE 2018 Runtime
baseurl=https://yum.repos.intel.com/2018
enabled=1
gpgcheck=1
gpgkey=file:///etc/pki/rpm-gpg/RPM-GPG-KEY-intel-psxe-runtime-2018
EOL

rpm --import https://yum.repos.intel.com/2018/setup/RPM-GPG-KEY-intel-psxe-runtime-2018
yum update -y
yum install -y intel-psxe-runtime
