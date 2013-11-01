Vagrant.configure("2") do |config|
  config.vm.define 'opentsdb_standalone' do |opentsdb_standalone|
    opentsdb_standalone.vm.box = 'precise-cloud64'
    opentsdb_standalone.vm.box_url = 'http://cloud-images.ubuntu.com/vagrant/precise/current/precise-server-cloudimg-amd64-vagrant-disk1.box'
    opentsdb_standalone.vm.hostname = 'opentsdbstandalone.dev.whoopdev.com'
    opentsdb_standalone.vm.network :public_network

    opentsdb_standalone.vm.provision :chef_solo do |chef|
      chef.run_list = [
          "recipe[opentsdb::default]"
      ]
      chef.log_level = :debug
    end
  end

  config.vm.define 'test' do |test|
    test.vm.box = 'precise-cloud64'
    test.vm.box_url = 'http://cloud-images.ubuntu.com/vagrant/precise/current/precise-server-cloudimg-amd64-vagrant-disk1.box'
    test.vm.hostname = 'opentsdbstandalone.dev.whoopdev.com'
    test.vm.network :public_network

    test.vm.provision :chef_solo do |chef|
      chef.run_list = []
      chef.log_level = :debug
    end
  end

  config.berkshelf.enabled = true
  config.omnibus.chef_version = :latest
end
