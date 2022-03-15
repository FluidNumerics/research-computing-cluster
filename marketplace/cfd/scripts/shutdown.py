#!/usr/bin/python3


def get_instance_metadata(key):
    """Gets instance metadata given a metadata key"""
    import urllib.request

    GOOGLE_URL = "http://metadata.google.internal/computeMetadata/v1/instance/attributes"
    req = urllib.request.Request("{}/{}".format(GOOGLE_URL, key))
    req.add_header('Metadata-Flavor', 'Google')
    resp = urllib.request.urlopen(req)

    value = resp.read().decode('utf-8').replace('\t','')
    return value

#END get_instance_metadata

def run(cmd):
    """Runs a command in the local environment and returns exit code, stdout, and stderr"""
    import subprocess

    proc = subprocess.Popen(cmd,
                            shell=True,
                            stdout=subprocess.PIPE,
                            stderr=subprocess.PIPE)

    stdout, stderr = proc.communicate()

    return stdout, stderr, proc.returncode

#END run

def spindownComputeNodes():
    """Looks for compute nodes associated with a Slurm cluster and deletes the instances"""
    import googleapiclient.discovery
    import json

    scontrol = '/usr/local/bin/scontrol'
    config = json.loads(get_instance_metadata('config'))
    compute = googleapiclient.discovery.build('compute', 'v1',
                                              cache_discovery=False)
    page_token = ""
    g_nodes = []
    for partition in config['partitions']:
        while True:
            resp = compute.instances().list(project=config['project'],
                      zone=partition['zone'], pageToken=page_token,
                      filter='name={}-compute*'.format(config['cluster_name'])).execute()

            if "items" in resp:
                g_nodes.extend(resp['items'])
            if "nextPageToken" in resp:
                page_token = resp['nextPageToken']
                continue

            break;

    if(len(g_nodes)):
        for node in g_nodes:
            cmd = "{} update node={} state=power_down".format(scontrol, node['name'])
            stdout, stderr, rc = run(cmd)
            if rc == 0:
                try:
                    print(stdout.decode('utf-8'))
                except:
                    print(stdout)
            else:
                try:
                    print(stdout.decode('utf-8'))
                    print(stderr.decode('utf-8'))
                except:
                    print(stdout)
                    print(stderr)

#END spindownComputeNodes

if __name__ == "__main__":
    spindownComputeNodes()
