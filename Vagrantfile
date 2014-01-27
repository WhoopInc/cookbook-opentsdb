Vagrant.require_plugin "vagrant-berkshelf"
Vagrant.require_plugin "vagrant-vbguest"
Vagrant.require_plugin "vagrant-omnibus"

Vagrant.configure("2") do |config|
  config.vm.define 'opentsdb_standalone' do |opentsdb_standalone|
    opentsdb_standalone.vm.box = 'precise-cloud64'
    opentsdb_standalone.vm.box_url = 'http://cloud-images.ubuntu.com/vagrant/precise/current/precise-server-cloudimg-amd64-vagrant-disk1.box'
    opentsdb_standalone.vm.hostname = 'opentsdbstandalone.dev.whoopdev.com'

    opentsdb_standalone.vm.provision :chef_solo do |chef|
      chef.run_list = [
          "recipe[opentsdb::default]"
      ]
      chef.log_level = :debug
    end
  end

  config.berkshelf.enabled = true
  config.omnibus.chef_version = '11.8.2'
end

# Prevent Chef output buffering [CHEF-4725]
# See: https://tickets.opscode.com/browse/CHEF-4725
class<<Vagrant::Util::TemplateRenderer;alias r render;def render(*a);r(*a)<<(a[0]=~/solo$/?"\nlog_location STDOUT":"");end;end
