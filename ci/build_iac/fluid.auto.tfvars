zone="us-central1-c"
subnet="default"

tags = [
          { prefix="v3.0.*",
            name="RCC-Centos-7-v30-release",
            img_family="rcc-centos-7-v300"
            project = "research-computing-cloud"
            description = "Research computing cluster (CentOS RCC v3.0)"
            packer_json = "img/centos/packer.rcc.json"
            disabled = false
            config = "ci/cloudbuild.tag.yaml"
          },
          { prefix="v3.0.*",
            name="RCC-Debian-10-v30-release",
            img_family="rcc-debian-10-v300"
            project = "research-computing-cloud"
            description = "Research computing cluster (Debian RCC v3.0)"
            packer_json = "img/debian/packer.rcc.json"
            disabled = false
            config = "ci/cloudbuild.tag.yaml"
          },
          { prefix="v3.0.*",
            name="RCC-Centos-7-v30-release-fco",
            img_family="rcc-centos-7-v300"
            project = "fluid-cluster-ops"
            description = "Research computing cluster (CentOS RCC v3.0)"
            packer_json = "img/centos/packer.marketplace.json"
            disabled = false
            config = "ci/cloudbuild.tag.yaml"
          },
          { prefix="v3.0.*",
            name="RCC-Debian-10-v30-release-fco",
            img_family="rcc-debian-10-v300"
            project = "fluid-cluster-ops"
            description = "Research computing cluster (Debian RCC v3.0)"
            packer_json = "img/debian/packer.marketplace.json"
            disabled = false
            config = "ci/cloudbuild.tag.yaml"
          }
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
