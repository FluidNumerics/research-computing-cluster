zone="us-central1-c"
subnet="default"

builds = [{ branch="v3.0.x",
            img_family="rcc-centos-7-v3"
            project = "fluid-cluster-ops"
            description = "Research computing cluster (CentOS Marketplace v3.0)"
            packer_json = "img/centos/packer.marketplace.json"
          },
          { branch="v3.0.x",
            img_family="rcc-centos-7-v3"
            project = "research-computing-cloud"
            description = "Research computing cluster (CentOS RCC v3.0)"
            packer_json = "img/centos/packer.rcc.json"
          }
         ]
