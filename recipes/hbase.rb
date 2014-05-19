include_recipe 'opentsdb::java'

distro = node['lsb']['codename']

apt_repository 'cloudera_cdh' do
  uri          "http://archive.cloudera.com/cdh4/ubuntu/#{distro}/amd64/cdh"
  distribution "#{distro}-cdh4"
  components   ['contrib']
  key          "http://archive.cloudera.com/cdh4/ubuntu/#{distro}/amd64/cdh/archive.key"
  arch         'amd64'
  deb_src      true
  action       :add
end

%w(hbase hbase-master).each do |name|
  package name
end

apt_repository 'cloudera_gplextras' do
  uri          "http://archive.cloudera.com/gplextras/ubuntu/#{distro}/amd64/gplextras/"
  distribution "#{node['lsb']['codename']}-gplextras4"
  components   ['contrib']
  key          "http://archive.cloudera.com/gplextras/ubuntu/#{distro}/amd64/gplextras/archive.key"
  arch         'amd64'
  deb_src      true
  action       :add
  only_if      { node['hbase']['lzo_compression'] }
end

%w(lzop hadoop-lzo-cdh4).each do |name|
  package name do
    only_if { node['hbase']['lzo_compression'] }
  end
end

directory node['hbase']['root_dir'] do
  owner    'hbase'
  group    'hbase'
  mode      0755
  recursive true
end

chef_conf_dir = "/etc/hbase/#{node['hbase']['conf_dir']}"

template "#{chef_conf_dir}/hbase-env.sh" do
  source 'hbase-env.sh.erb'
  notifies :restart, 'service[hbase-master]'
end

template "#{chef_conf_dir}/hbase-site.xml" do
  source 'hbase-site.xml.erb'
  notifies :restart, 'service[hbase-master]'
end

execute 'update_hbase_conf_alternatives' do
  command <<-EOC
    update-alternatives --install \
      /etc/hbase/conf hbase-conf #{chef_conf_dir}" 60
  EOC
end

service 'hbase-master' do
  action :start
  supports :status => true, :restart => true
end