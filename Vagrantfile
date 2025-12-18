# -*- mode: ruby -*-
# vi: set ft=ruby :

require 'yaml'
require 'pathname'

STDERR.puts "https://github.com/kamuridesu/VagrantYAML"

default_image = "debian/buster64"

file = ENV['INV_FILE']

USERNAME = Gem.win_platform? ? "#{ENV['USERNAME']}" : "#{ENV['USER']}"

if file != nil then
  if ! Pathname.new(file).exist? then
    abort "ERROR: file \"#{file}\" does not exists!"
  end
else
  if ! Pathname.new("vagrant.yml").exist? then
    abort "ERROR: Expecting a configuration file!"
  end
  file = "vagrant.yml"
end

INVENTORY = YAML.load_file(File.join(File.dirname(__FILE__), file))

rsync_exclude = []

if (INVENTORY.has_key?("RSYNC_EXCLUDE")) && (INVENTORY.has_key?("RSYNC_EXCLUDE".to_sym))
  rsync_exclude = INVENTORY['RSYNC_EXCLUDE']
end

if (!INVENTORY.has_key?("MACHINES")) && (!INVENTORY.has_key?("MACHINES".to_sym))
  abort "ERROR: Missing MACHINES parameter!"
end

if ((INVENTORY.has_key?("IMAGE")) || (INVENTORY.has_key?("IMAGE".to_sym))) && INVENTORY['IMAGE'] != "" && INVENTORY['IMAGE'] != nil
  default_image = INVENTORY['IMAGE']
else
  puts "WARNING: Using default #{default_image} because no IMAGE was set in the inventory file!"
end

["NAME", "CPU", "MEMORY", "IP"].each do |key|
  INVENTORY['MACHINES'].each_with_index do |conf, idx|
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

      box.ssh.insert_key = false

      box.vm.box_check_update = false
      box.vm.network "private_network", ip: virtualmachines["IP"]
      box.vm.hostname = virtualmachines["NAME"]

      if virtualmachines.has_key?("BOX")
        box.vm.box = virtualmachines["BOX"]
      end

      box.vm.synced_folder ".", "/vagrant", type: "rsync",
        rsync__exclude: [".git/"] + (defined?(rsync_exclude) ? rsync_exclude : [])

      box.vm.provider "virtualbox" do |vb|
        vb.memory = virtualmachines["MEMORY"]
        vb.cpus = virtualmachines["CPU"]
      end

      box.vm.provider "libvirt" do |lv|
        lv.memory = virtualmachines["MEMORY"]
        lv.cpus = virtualmachines["CPU"]

        if virtualmachines["ARCH"] == "arm64" || virtualmachines["ARCH"] == "aarch64"
          lv.driver = "qemu"
          lv.machine_arch = "aarch64"
          lv.machine_type = "virt"
          lv.cpu_mode = "custom"
        else
          lv.driver = "kvm"
        end
      end

      if (virtualmachines.has_key?("SCRIPT")) then
        box.vm.provision "shell", path: virtualmachines["SCRIPT"]
      end

      if (virtualmachines.has_key?("SSH_PUB_KEY_FILE")) then
        box.vm.provision "shell" do |s|
          current_user = defined?(USERNAME) ? USERNAME : 'vagrant'
          ssh_pub_key = File.readlines(virtualmachines["SSH_PUB_KEY_FILE"].sub '$USER', current_user).first.strip()
          s.inline = <<-SHELL
            mkdir -p /home/vagrant/.ssh/
            mkdir -p /root/.ssh/
            echo "#{ssh_pub_key}" >> /home/vagrant/.ssh/authorized_keys
            echo "#{ssh_pub_key}" >> /root/.ssh/authorized_keys
            chmod 600 /home/vagrant/.ssh/authorized_keys
            chmod 600 /root/.ssh/authorized_keys
            chown -R vagrant:vagrant /home/vagrant/.ssh
          SHELL
        end
      end
    end
  end
end
