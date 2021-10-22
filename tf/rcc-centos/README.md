# RCC-CentOS

These terraform scripts deploy the Research Computing Cluster with a CentOS operating system.

You can view the product information for this solution at https://console.cloud.google.com/marketplace/fluid-cluster-ops/rcc-centos

Before deploying, review the End User License Agreement at https://help.fluidnumerics.com/eula

## How to deploy

To create a simple deployment with default configurations, you can simply run the following, replacing `PROJECT-ID` with your Google Cloud project ID.
```
export RCC_PROJECT=PROJECT-ID
make plan
```

This process will create a concretized Terraform variables file for this deployment called `basic.tfvars` and will generate a plan based on these definitions. If you would like to modify the deployment, (e.g. add a Lustre file system, set different compute partitions), you can edit `basic.tfvars` to meet your needs. You can review the meaning of each variable in [`io.tf`](./io.tf). When you are ready to deploy the cluster,
```
make apply
```

To delete resources,
```
make destroy
```
