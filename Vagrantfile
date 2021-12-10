$script = <<-SCRIPT
echo I am provisioning...
date > /etc/vagrant_provisioned_at

export DEBIAN_FRONTEND=noninteractive

wget https://apt.puppet.com/puppet-tools-release-bionic.deb
sudo dpkg --force-confold -i puppet-tools-release-bionic.deb
sudo apt-get update
sudo apt-get install -y puppet-bolt

SCRIPT

Vagrant.configure("2") do |config|
  config.vm.box = "hashicorp/bionic64"

  # config.vm.provision "shell", inline: $script

  #  config.vm.provider "virtualbox" do |vb|
  #    vb.memory = "4096"
  #    v.memory = 1024
  #    v.cpus = 2
  #  end
end
