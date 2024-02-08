#!/bin/bash

help() {
    echo "CLI helper for VagrantYAML."
    echo "Usage: "
    echo "    cli --init: create the configuration files"
    echo "    cli --help: shows this menu"
}

init() {
    FILE_URL=https://raw.githubusercontent.com/kamuridesu/VagrantYAML/main/Vagrantfile
    INVENTORY_FILE=https://raw.githubusercontent.com/kamuridesu/VagrantYAML/main/vagrant.yml
    echo "Downloading Vagrantfile"
    curl -sSL $FILE_URL --output Vagrantfile
    echo "Creating inventory file"
    curl -sSL $INVENTORY_FILE --output vagrant.yml
    echo "Done!"
}

INIT=

while [[ $# -gt 0 ]]; do
    case $1 in
        -i|--init)
            INIT=1
            shift
            ;;
        -h|--help)
            help
            exit 0
    esac
done

if [[ $INIT -eq 1 ]]; then
    init
else
    help
fi