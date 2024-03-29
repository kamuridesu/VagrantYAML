# VagrantYAML

Vagrant config file that reads a YAML file with the machines configuration.

## Requirements:

[Vagrant](https://developer.hashicorp.com/vagrant/downloads)

[Virtualbox](https://www.virtualbox.org/wiki/Downloads)

## Setup

You'll need a file containing the configs of your machines, like:

```YAML
IMAGE: "debian/bullseye64"
MACHINES:
  - NAME: "master01"
    CPU: "2"
    MEMORY: "4000"
    TYPE: "master"
    IP: 10.0.1.100
    SSH_PUB_KEY_FILE: /home/user/.ssh/id_rsa.pub # optional
    SCRIPT: master.sh # optional

  - NAME: "worker01"
    CPU: "2"
    MEMORY: "2000"
    TYPE: "worker"
    IP: 10.0.1.101
    SSH_PUB_KEY_FILE: /home/user/.ssh/id_rsa.pub # optional
    SCRIPT: worker.sh # optional
```

Where:
  - IMAGE: Image to be used by the VMs
  - MACHINES: List with the machines to be configured
  - NAME: is the name of the VM
  - CPU: number of CPU cores
  - MEMORY: memory of the VMs
  - TYPE: type of the machine (worker, master)
  - IP: IP address of the machine
  - SCRIPT: (Optional) Script to provision the vm
  - SSH_PUB_KEY_FILE: (Optional) path for SSH Public Key


You can check this repo to find examples.

## Running

### Windows

First, setup a ENV variable with your filename:

```powershell
$env:INV_FILE = "inv.yaml"
```

Then just call Vagrant:

```powershell
vagrant up
```

### Linux

Define your ENV variable with the name of your inventory file and call Vagrant:

```sh
INV_FILE='inv.yaml' vagrant up
```

Or

```sh
export INV_FILE='inv.yaml'
vagrant up
```
