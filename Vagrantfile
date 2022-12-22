# -*- mode: ruby -*-
# vi: set ft=ruby :

require 'yaml'
require 'pathname'

default_image = "debian/buster64"

file = ENV['INV_FILE']

if file != nil then
  if ! Pathname.new(file).exist? then
    abort "ERROR: file \"#{file}\" does not exists!"
  end
else
  abort "ERROR: Expecting a configuration file!"
end

INVENTORY = YAML.load_file(File.join(File.dirname(__FILE__), file))

if (!INVENTORY.has_key?("MACHINES")) && (!INVENTORY.has_key?("MACHINES".to_sym))
  abort "ERROR: Missing MACHINES parameter!"
end
if ((INVENTORY.has_key?("IMAGE")) || (INVENTORY.has_key?("IMAGE".to_sym))) && INVENTORY['IMAGE'] != "" && INVENTORY['IMAGE'] != nil
  default_image = INVENTORY['IMAGE']
else
  puts "WARNING: Using default #{default_image} because no IMAGE was set in the inventory file!"
end
["NAME", "CPU", "MEMORY", "IP", "TYPE"].each do |key|
  INVENTORY['MACHINES'].each_with_index do |conf, idk|
    if (!conf.has_key?(key)) && (!conf.has_key?(key.to_sym))
      abort "ERROR: Missing parameter \"#{key}\" on the machine number #{idx + 1} of the inventory file!"
    end
  end
end

MACHINES = INVENTORY['MACHINES']

Vagrant.configure("2") do |config|

  config.vm.box = default_image
  config.vm.synced_folder ".", "/vagrant"
  MACHINES.each do |virtualmachines|
    config.vm.define virtualmachines["NAME"] do |box|

      box.vm.box_check_update = false
      box.vm.network "private_network", ip: virtualmachines["IP"]
      box.vm.hostname = virtualmachines["NAME"]

      box.vm.synced_folder ".", "/vagrant", type: "rsync",
        rsync__exclude: [".git/", "data/", "data/*", "data/**", "data/postgres"]

      box.vm.provider "virtualbox" do |vb|
        vb.memory = virtualmachines["MEMORY"]
        vb.cpus = virtualmachines["CPU"]
      end

      if virtualmachines["TYPE"] == "master" then
        box.vm.provision "shell", path: "configs/shell/provision_master.sh"
      elsif virtualmachines["TYPE"] == "worker" then
        box.vm.provision "shell", path: "configs/shell/provision_worker.sh"
      end
    end
  end
end
