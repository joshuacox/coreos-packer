# -*- mode: ruby -*-
# # vi: set ft=ruby :

if Vagrant::VERSION < "1.5.4"
  raise "Need at least Vagrant version 1.5.4, please update"
end

require_relative "change_host_name.rb"
require_relative "configure_networks.rb"

Vagrant.configure("2") do |config|
  # SSH in as the default 'core' user, it has the vagrant ssh key.
  config.ssh.username = "core"

  # Disable the base shared folder, Guest Additions are unavailable.
  config.vm.synced_folder ".", "/vagrant", disabled: true

  config.vm.provider :virtualbox do |vb|
    # Guest Additions are unavailable.
    vb.check_guest_additions = false

    # Fix docker not being able to resolve private registry in VirtualBox
    vb.customize ["modifyvm", :id, "--natdnshostresolver1", "on"]
    vb.customize ["modifyvm", :id, "--natdnsproxy1", "on"]
  end

  config.vm.provider :parallels do |prl|
    # Guest Tools are unavailable.
    prl.check_guest_tools = false
 end
end
