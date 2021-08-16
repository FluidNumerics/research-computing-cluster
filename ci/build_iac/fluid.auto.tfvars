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
          },
          { branch="v3.0.x",
            img_family="rcc-centos-7-intel-v3"
            project = "research-computing-cloud"
            description = "Research computing cluster ([Intel Select] CentOS RCC v3.0)"
            packer_json = "img/centos-intel/packer.rcc.json"
          },
          { branch="v3.0.x",
            img_family="rcc-debian-10-v3"
            project = "fluid-cluster-ops"
            description = "Research computing cluster (Debian Marketplace v3.0)"
            packer_json = "img/debian/packer.marketplace.json"
          },
          { branch="v3.0.x",
            img_family="rcc-debian-10-v3"
            project = "research-computing-cloud"
            description = "Research computing cluster (Debian RCC v3.0)"
            packer_json = "img/debian/packer.rcc.json"
          },
          { branch="v3.0.x",
            img_family="rcc-ubuntu-2004-v3"
            project = "fluid-cluster-ops"
            description = "Research computing cluster (Ubuntu Marketplace v3.0)"
            packer_json = "img/ubuntu/packer.marketplace.json"
          },
          { branch="v3.0.x",
            img_family="rcc-ubuntu-2004-v3"
            project = "research-computing-cloud"
            description = "Research computing cluster (Ubuntu RCC v3.0)"
            packer_json = "img/ubuntu/packer.rcc.json"
          }
         ]
