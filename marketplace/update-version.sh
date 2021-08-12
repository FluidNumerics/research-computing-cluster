#!/bin/bash

sed -i -e "s/$1/$2/g" fluid-slurm-gcp-centos/Slurm-GCP.jinja
sed -i -e "s/$1/$2/g" fluid-slurm-gcp-centos/Slurm-GCP.jinja.display
sed -i -e "s/$1/$2/g" fluid-slurm-gcp-centos/controller_tier.jinja
sed -i -e "s/$1/$2/g" fluid-slurm-gcp-centos/login_tier.jinja
sed -i -e "s/$1/$2/g" fluid-slurm-gcp-centos/compute_tier.jinja
sed -i -e "s/$1/$2/g" fluid-slurm-gcp-centos/c2d_deployment_configuration.json
sed -i -e "s/$1/$2/g" fluid-slurm-gcp-centos/scripts/cluster-config.json
