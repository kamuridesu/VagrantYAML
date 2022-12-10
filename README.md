# VagrantYAML

Vagrant config file that reads a YAML file with the machines configuration.

## Requirements:

[Vagrant](https://developer.hashicorp.com/vagrant/downloads)

## Setup

You'll need a file containing the configs of your machines, like:

```YAML
- NAME: "master01"
  CPU: "2"
  MEMORY: "2000"
  TYPE: "master"
  IP: 10.0.1.100

- NAME: "worker01"
  CPU: "2"
  MEMORY: "2000"
  TYPE: "worker"
  IP: 10.0.1.101
```

Where:
    - Name: is the name of the VM
    - CPU: number of CPU cores
    - MEMORY: memory of the VMs
    - TYPE: type of the machine (worker, master)
    - IP: IP address of the machine

And the .sh config files for each type of machine.

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