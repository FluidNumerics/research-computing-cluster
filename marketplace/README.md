# Slurm-GCP Marketplace Deployment

Requires [Deployment Manager Autogen](https://github.com/GoogleCloudPlatform/deploymentmanager-autogen)

## Getting Started
It's easiest to work on the marketplace deployment with autogen in Cloud Shell.
In cloud shell, execute
```
alias autogen='docker run \
   --rm \
   --workdir /mounted \
   --mount type=bind,source="$(pwd)",target=/mounted \
   --user $(id -u):$(id -g) \
   gcr.io/cloud-marketplace-tools/dm/autogen'
```
to create an alias for the Marketplace team's autogen Docker image. You can test that autogen works by executing
```
autogen --help
```
You should see output like
```
Unable to find image 'gcr.io/cloud-marketplace-tools/dm/autogen:latest' locally
latest: Pulling from cloud-marketplace-tools/dm/autogen
41d633039bbf: Pull complete
5f5edd681dcb: Pull complete
3e010093287c: Pull complete
92e3c1d4d4f8: Pull complete
333b6f04c6a7: Pull complete
Digest: sha256:f4b714f3bf5eeba1940147cf36f83d177d81f11446153a98ab0b1b3765d0a68e
Status: Downloaded newer image for gcr.io/cloud-marketplace-tools/dm/autogen:latest
usage: Autogen
    --batch_input <arg>              Input source, a filename or empty for
                                     stdin, for batch Solution processing.
                                     See BatchInput proto
    --exclude_shared_support_files   Whether to exclude symlinkable shared
                                     support files
    --help                           Prints usage help
    --input_type <arg>               Input content type
    --output <arg>                   Output destination folder if
                                     output_type is PACKAGE, or filename
                                     otherwise (Optional, current
                                     directory will be used for
                                     output_type PACKAGE and stdout for
                                     other types, if option not present)
    --output_type <arg>              Output content type
    --single_input <arg>             Input source, a filename or empty for
                                     stdin, for single Solution
                                     processing. See
                                     DeploymentPackageInput proto
```

To create a package
```
autogen --input_type YAML --single_input solution.yaml --output_type PACKAGE --output solution_folder
```

Zip the "solution_folder" and upload to the partner portal.
