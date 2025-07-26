# generate_vagrantfile.py
vagrantfile = """
Vagrant.configure("2") do |config|
  # Master Node
  config.vm.define "master" do |master|
    master.vm.box = "ubuntu/jammy64"  # Ubuntu 22.04 LTS
    master.vm.hostname = "k8s-master"
    master.vm.network "private_network", ip: "192.168.56.10"
    master.vm.provider "virtualbox" do |vb|
      vb.memory = 1024  # 1GB RAM
      vb.cpus = 1       # 1 CPU
    end
  end

  # Worker Node
  config.vm.define "node" do |node|
    node.vm.box = "ubuntu/jammy64"  # Ubuntu 22.04 LTS
    node.vm.hostname = "k8s-node"
    node.vm.network "private_network", ip: "192.168.56.11"
    node.vm.provider "virtualbox" do |vb|
      vb.memory = 1024  # 1GB RAM
      vb.cpus = 1       # 1 CPU
    end
  end
end
"""

with open("Vagrantfile", "w") as f:
    f.write(vagrantfile)

print("Vagrantfile généré avec succès!")
