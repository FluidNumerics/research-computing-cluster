# RCC-CFD

These terraform scripts deploy the Research Computing Cluster with a CentOS operating system and the following applications installed
* OpenFOAM-org (v8)
* Paraview (v5.10.0)
* Gmsh

You can view the product information for this solution at https://console.cloud.google.com/marketplace/fluid-cluster-ops/cloud-cfd

Before deploying, review the End User License Agreement at https://help.fluidnumerics.com/eula

## How to deploy

**[Codelab : Run the NACA0012 Aerofoil OpenFOAM® Benchmark on Google Cloud](https://fluidnumerics.github.io/rcc-codelabs/cloud-cfd/run-openfoam-on-gcp-with-cloud-cfd/#0)**

To create a simple deployment with default configurations, you can simply run the following, replacing `[PROJECT-ID]` with your Google Cloud project ID and `[ZONE]` with the desired zone on Gooogle Cloud to deploy your cluster.
```
export RCC_PROJECT=[PROJECT-ID]
export RCC_ZONE=[ZONE]
export RCC_NAME="cfd-demo"
make plan
```
**Important**: You will want to deploy the cluster to [a zone that hosts c2d instances](https://cloud.google.com/compute/docs/regions-zones). A few options are us-central1-a, us-central1-c, us-central1-f, europe-west4-c. You can find a more complete list at [Google Cloud's Regions and Zones documentation](https://cloud.google.com/compute/docs/regions-zones).


This process will create a concretized Terraform variables file for this deployment called `basic.tfvars` and will generate a plan based on these definitions. If you would like to modify the deployment, (e.g. add a Lustre file system, set different compute partitions), you can edit `basic.tfvars` to meet your needs. You can review the meaning of each variable in [`io.tf`](./io.tf). When you are ready to deploy the cluster,
```
make apply
```

To delete resources,
```
make destroy
```

**For a more complete walkthrough, check out [the codelab to run the NACA0012 benchmark](https://fluidnumerics.github.io/rcc-codelabs/cloud-cfd/run-openfoam-on-gcp-with-cloud-cfd/#0) using this solution**
