#!/usr/bin/env bash

export INSTANCE_TYPE="@INSTANCE_TYPE@" 
export CLUSTER_NAME="@CLUSTER_NAME@"
export DISABLE_HYPERTHREADING="@DISABLE_HYPERTHREADING@"
export PRINT_LOGS="False"
export SPINUP_TEST="False"
export ZONE="@ZONE@"

if [ "$INSTANCE_TYPE" != "controller" ]; then
  # Make sure other instances mount the /apps directory prior to executing any cluster services
  mkdir -p /apps
  echo "${CLUSTER_NAME}-controller:/apps	/apps	nfs	rw,hard,intr	0	0" >> /etc/fstab
  echo "${CLUSTER_NAME}-controller:/home	/home	nfs	rw,hard,intr	0	0" >> /etc/fstab
  echo "${CLUSTER_NAME}-controller:/etc/munge    /etc/munge     nfs      rw,hard,intr  0     0" >> /etc/fstab
  echo "# ADDITIONAL MOUNTS #" >> /etc/fstab
  mount -a
else
  systemctl enable nfs-server
  systemctl start nfs-server
fi

/apps/cls/bin/cluster-services setup

 
if [ "$INSTANCE_TYPE" == "gpu-compute" ]; then
  nvidia-smi # Creates the device files
  systemctl enable nvidia-persistenced
  systemctl start nvidia-persistenced
  /sbin/modprobe nvidia-uvm
  mknod -m 666 /dev/nvidia-uvm c $(grep nvidia-uvm /proc/devices | awk '{print $1}') 0
fi

if [ "$DISABLE_HYPERTHREADING" == "True" ]; then
  sh /apps/hyperthreading/manage_hyperthreading.sh -d
fi

if [ "$INSTANCE_TYPE" == "compute" ] || [ "$INSTANCE_TYPE" == "gpu-compute" ]; then
  service slurmd start
fi

/apps/cls/bin/cluster-services system-checks

# FSG-462
gcloud compute instances remove-metadata $(hostname) --zone=$ZONE --keys="startup-script","cluster-config"

