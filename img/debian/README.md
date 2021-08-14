# Slurm GCP Imaging
This repository is used for creating images for the controller, login, and compute nodes for the image based, multi-partition slurm-gcp deployment ( https://bitbucket.org/fluidnumerics/slurm-gcp )

## Getting Started
As a developer on the slurm-gcp-imaging repository, you should be aware of the overall development strategy employed by the current development team. The slurm-gcp-imaging development team has two GCP projects for hosting development and production images of the controller, login, and compute node images.

* fluidnumerics.com/fluid-cluster/fluid-cluster-dev : Automatically builds images for controller, login, and compute nodes when changes are made to the develop branch of [slurm-gcp-imaging](https://bitbucket.org/fluidnumerics/slurm-gcp-imaging)

* fluidnumerics.com/fluid-cluster/fluid-cluster-ops : Automatically builds images for controller, login, and compute nodes when changes are made to the master branch of [slurm-gcp-imaging](https://bitbucket.org/fluidnumerics/slurm-gcp-imaging)

Because of this, the develop and master branches are protected branches, requiring passing testing and reviews from repository administrators.

To contribute to the repository, you should create an appropriate feature or bugfix branch from the most recent version of the develop branch. On your feature branch, you can make the desired changes to the repository and create feature builds of the controller, login, and compute node images in your own GCP project.

### Setting up your GCP project
Images for the controller, login, and compute nodes can be built by using Google Cloud Builds and the provided [cloudbuild.yaml](cloudbuild.yaml). This build system depends on a custom build step builder for [Packer](https://www.packer.io). Below we provide the steps necessary to begin developing in your own project on GCP.

1. Enable the Cloud Build and Compute Engine APIs in your project. 
```
gcloud services enable cloudapis.googleapis.com
gcloud services enable servicemanagement.googleapis.com
gcloud services enable compute.googleapis.com
gcloud services enable cloudbuild.googleapis.com
```
2. Add a firewall rule to the default network that allows ssh.
```
gcloud compute firewall-rules create default-allow-ssh --allow=tcp:22 --source-ranges=0.0.0.0/0
```
3. Build the Packer builder. From the root directory of this repository,
```
$ cd packer/
$ gcloud builds submit .
```
4. Provide your project's cloud build service account the `Compute Admin` and `Service Account User` Roles. To do this, navigate to the IAM & Admin page on your GCP project. Edit the `PROJECT_NUMBER@cloudbuild.gserviceaccount.com` and add the `Compute Admin` and `Service Account User` roles. This is needed so that the Cloud Build service can create and delete GCE Instances.
5. Test that the builder is working by building from the develop branch. From the root directory of this repository, 
```
$ git checkout origin/develop -b develop
$ gcloud builds submit .
```
The build system will automatically detect your GCP project id and execute the build under that project. If you are using the gcloud SDK on your own system, you can set your project id
```
gcloud config set project PROJECT_ID
```
replacing `PROJECT_ID` with your project id.

### Customizing Build Options
The Cloud Build system currently accepts the following optional variables

* `_FAMILY_TAG` : This is the postfixed tag applied to the images you create during the build process. For example, setting `gcloud builds submit . --substitutions=_FAMILY_TAG=-latest` creates controller, login, and compute node images under the families slurm-controller-latest, slurm-login-latest, slurm-compute-latest respectively. The default value for the family tag is an empty string.

* `_ZONE` : This is the zone where packer deployes temporary GCE instances that are used to bake the images.

