# -*- mode: ruby -*-
# vi: set ft=ruby :

#############
# VARIABLES #
#############

BOX_IMAGE="generic/rocky9"
PROJECT_ID="2"


###################
# KEY GENERATION  #
# #################

# provides utilities for copying, moving, deleting, and creating files and directories
require 'fileutils'

SSH_KEY_PATH = File.join(__dir__, "vagrant", ".ssh")
SSH_KEY_PRIVATE = File.join(SSH_KEY_PATH, "ansible_lab")
SSH_KEY_PUBLIC = "#{SSH_KEY_PRIVATE}.pub"

FileUtils.mkdir_p(SSH_KEY_PATH)

unless File.exist?(SSH_KEY_PRIVATE)
    system(
      "ssh-keygen",
      "-t", "ed25519",
      "-f", SSH_KEY_PRIVATE,
      "-N", "",
      "-C", "vagrant-ansible-lab"
    )  
end

Vagrant.configure("2") do |config|

  config.vm.box = BOX_IMAGE
  config.vm.synced_folder ".", "/vagrant", disabled: false
  config.vm.provider "virtualbox" do |vb|
  #   # Display the VirtualBox GUI when booting the machine
     vb.gui = false
   end

MANAGED_NODES = [
    { name: "managed-201", ip: "192.168.56.11", memory: 1024, cpus: 1 }
    ]
  MANAGED_NODES.each do |srv|
    config.vm.define srv[:name], autostart: true do |node|
      node.vm.hostname = srv[:name]
      node.vm.network "private_network", ip: srv[:ip]
      node.vm.provider "virtualbox" do |vb|
        vb.name = srv[:name]
        vb.memory = srv[:memory]
        vb.cpus = srv[:cpus]
      end
      node.vm.provision "shell",
        path: "scripts/deploy-public-key.sh",
        privileged:false
      end
  end

   CONTROLLER = { name: "controller-201", ip: "192.168.56.10", memory: 2048, cpus: 2 }
   config.vm.define CONTROLLER[:name] do |controller|
      controller.vm.hostname = CONTROLLER[:name]
      controller.vm.network "private_network", ip: CONTROLLER[:ip]
      controller.vm.provider "virtualbox" do |vb|
                vb.name = CONTROLLER[:name]
                vb.memory = CONTROLLER[:memory]
                vb.cpus = CONTROLLER[:cpus]
      end
      controller.vm.provision "shell",
        path: "scripts/bootstrap-ansible-controller.sh",
        privileged: false
      controller.vm.provision "shell",
        path: "scripts/deploy-private-key.sh",
        privileged: false
      end
end