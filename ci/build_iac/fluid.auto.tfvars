project = "fluid-cluster-ops"
zone="us-central1-c"
subnet="default"

builds = [{ branch="v3.0.x",
            img_family="fluid-slurm-gcp-centos-7-v3"
          },
          { branch="main",
            img_family="fluid-slurm-gcp-centos-7-latest"
          }
         ]
