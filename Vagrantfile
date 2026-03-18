# Vagrantfile for Windows (VirtualBox)
# Docker will be automatically installed on first boot

Vagrant.configure("2") do |config|

  config.vm.box = "ubuntu/focal64"

  # Private (host-only) network
  config.vm.network "private_network", ip: "54.147.40.16"

  # Public (bridged) network
  config.vm.network "public_network"

  # VirtualBox provider configuration
  config.vm.provider "virtualbox" do |vb|
    vb.memory = 2048
    vb.cpus = 2
    vb.name = "sca-aws"
  end

  # Provisioning: Install Docker automatically
  config.vm.provision "shell", path: "provision.sh"

end