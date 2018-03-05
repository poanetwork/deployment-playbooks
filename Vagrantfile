
ENV["LC_ALL"] = "en_US.UTF-8"

Vagrant.configure("2") do |config|
  config.vm.box = "ubuntu/xenial64"
  config.vm.hostname = "validator"
  config.vm.network "private_network", ip: "192.168.57.10"

  config.vm.provider "virtualbox" do |vb|
    vb.memory = "1024"
  end
  
end
