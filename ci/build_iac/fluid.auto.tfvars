zone="us-central1-c"
subnet="default"

tags = [
          { prefix="v3.0.*",
            name="RCC-Centos-7-v30-release-fco",
            img_family="rcc-centos-7-v300"
            project = "fluid-cluster-ops"
            description = "Research computing cluster (CentOS RCC v3.0)"
            packer_json = "img/centos/packer.marketplace.json"
            disabled = true
            config = "ci/cloudbuild.marketplace.yaml"
            rcc_file = "marketplace/centos/rcc-cluster.yaml"
          },
          { prefix="v3.0.*",
            name="RCC-Debian-10-v30-release-fco",
            img_family="rcc-debian-10-v300"
            project = "fluid-cluster-ops"
            description = "Research computing cluster (Debian RCC v3.0)"
            packer_json = "img/debian/packer.marketplace.json"
            disabled = true
            config = "ci/cloudbuild.marketplace.yaml"
            rcc_file = "marketplace/debian/rcc-cluster.yaml"
          },
          { prefix="v3.0.*",
            name="RCC-Ubuntu-v30-release-fco",
            img_family="rcc-ubuntu-2004-v300"
            project = "fluid-cluster-ops"
            description = "Research computing cluster (Ubuntu RCC v3.0)"
            packer_json = "img/ubuntu/packer.marketplace.json"
            disabled = true
            config = "ci/cloudbuild.marketplace.yaml"
            rcc_file = "marketplace/ubuntu/rcc-cluster.yaml"
          },
          { prefix="wrf.*",
            name="RCC-WRF",
            img_family="rcc-wrf-v300-42"
            project = "fluid-cluster-ops"
            description = "Research computing cluster (CentOS RCC v3.0 - WRF v4.2)"
            packer_json = "img/wrf/packer.json"
            disabled = false
            config = "ci/cloudbuild.marketplace.yaml"
            rcc_file = "marketplace/wrf/rcc-cluster.yaml"
          },
          { prefix="v3.0.*",
            name="RCC-Rocky",
            img_family="rcc-rocky-v310"
            project = "fluid-cluster-ops"
            description = "Research computing cluster (Rocky Linux RCC v3.1.0)"
            packer_json = "img/rocky/packer.marketplace.json"
            disabled = false
            config = "ci/cloudbuild.marketplace.yaml"
            rcc_file = "marketplace/rocky/rcc-cluster.yaml"
          },
          { prefix="cfd.*",
            name="RCC-CFD-x86",
            img_family="rcc-cfd-gcc-x86"
            project = "fluid-cluster-ops"
            description = "Research computing cluster (CentOS RCC v3.0 - OpenFOAM8 x86)"
            packer_json = "img/cfd/packer.gcc.x86.json"
            disabled = false
            config = "ci/cloudbuild.marketplace.yaml"
            rcc_file = "marketplace/cfd/rcc-cluster.yaml"
          },
          { prefix="cfd.*",
            name="RCC-CFD-cascadelake",
            img_family="rcc-cfd-gcc-cascadelake"
            project = "fluid-cluster-ops"
            description = "Research computing cluster (CentOS RCC v3.0 - OpenFOAM8 cascadelake)"
            packer_json = "img/cfd/packer.gcc.cascadelake.json"
            disabled = false
            config = "ci/cloudbuild.marketplace.yaml"
            rcc_file = "marketplace/cfd/rcc-cluster.yaml"
          },
          { prefix="cfd.*",
            name="RCC-CFD-zen3",
            img_family="rcc-cfd-gcc-zen3"
            project = "fluid-cluster-ops"
            description = "Research computing cluster (CentOS RCC v3.0 - OpenFOAM8 zen3)"
            packer_json = "img/cfd/packer.gcc.zen3.json"
            disabled = false
            config = "ci/cloudbuild.marketplace.yaml"
            rcc_file = "marketplace/cfd/rcc-cluster.yaml"
          },
       ]

builds = [
          { branch="v3.0.0-alpha",
            name="RCC-Centos-7-v300-alpha-rcc",
            img_family="rcc-centos-7-v300-alpha"
            project = "research-computing-cloud"
            description = "alpha Research computing cluster (CentOS RCC v3.0)"
            packer_json = "img/centos/packer.rcc.json"
            disabled = false
          },
          { branch="v3.0.0-alpha",
            name="RCC-Debian-7-v300-alpha-rcc",
            img_family="rcc-debian-10-v300-alpha"
            project = "research-computing-cloud"
            description = "alpha Research computing cluster (CentOS RCC v3.0)"
            packer_json = "img/debian/packer.rcc.json"
            disabled = false
          }
         ]
