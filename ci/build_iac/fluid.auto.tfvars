zone="us-central1-c"
subnet="default"

builds = [
          { name="RCC-Centos-7-v3-rcc",
            branch="v3.0.x",
            img_family="rcc-centos-7-v3"
            project = "research-computing-cloud"
            description = "Research computing cluster (CentOS RCC v3.0)"
            packer_json = "img/centos/packer.rcc.json"
            disabled = true
          },
          { name="RCC-Debian-10-v3-rcc",
            branch="v3.0.x",
            img_family="rcc-debian-10-v3"
            project = "research-computing-cloud"
            description = "Research computing cluster (Debian RCC v3.0)"
            packer_json = "img/debian/packer.rcc.json"
            disabled = true
          },
          { branch="v3.0.x",
            name="RCC-Ubuntu-2004-v3-rcc",
            img_family="rcc-ubuntu-2004-v3"
            project = "research-computing-cloud"
            description = "Research computing cluster (Ubuntu RCC v3.0)"
            packer_json = "img/ubuntu/packer.rcc.json"
            disabled = true
          },
          { branch="v3.0.0-alpha",
            name="RCC-Debian-10-v300-alpha-fco",
            img_family="rcc-debian-10-v300-alpha"
            project = "fluid-cluster-ops"
            description = "alpha Research computing cluster (Debian Marketplace v3.0)"
            packer_json = "img/debian/packer.marketplace.json"
            disabled = true
          },
          { branch="v3.0.0-alpha",
            name="RCC-Centos-7-v300-alpha-fco",
            img_family="rcc-centos-7-v300-alpha"
            project = "fluid-cluster-ops"
            description = "alpha Research computing cluster (CentOS Marketplace v3.0)"
            packer_json = "img/centos/packer.marketplace.json"
            disabled = true
          },
          { branch="v3.0.0-alpha",
            name="RCC-Centos-7-v300-alpha-rcc",
            img_family="rcc-centos-7-v300-alpha"
            project = "research-computing-cloud"
            description = "alpha Research computing cluster (CentOS Marketplace v3.0)"
            packer_json = "img/centos/packer.rcc.json"
            disabled = false
          }
         ]
