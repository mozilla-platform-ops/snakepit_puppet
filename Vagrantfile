# bolt install script
$bolt_script = <<-SCRIPT
echo I am provisioning...
date > /etc/vagrant_provisioned_at

export DEBIAN_FRONTEND=noninteractive

wget https://apt.puppet.com/puppet-tools-release-bionic.deb
sudo dpkg --force-confold -i puppet-tools-release-bionic.deb
sudo apt-get update
sudo apt-get install -y puppet-bolt

SCRIPT

# TODO: add boxes for both roles

Vagrant.configure("2") do |config|
  config.vm.box = "hashicorp/bionic64"

  # needed if we're converging via bolt
  # config.vm.provision "shell", inline: $bolt_script

   config.vm.provider "virtualbox" do |vb|
     vb.memory = 2048
     vb.cpus = 4
   end

   # config.vm.hostname

  config.vm.define "head" do |machine|
    machine.vm.hostname = "mlchead.vagrant"
  end

  config.vm.define "worker" do |machine|
    machine.vm.hostname = "mlc0.vagrant"
  end

end
