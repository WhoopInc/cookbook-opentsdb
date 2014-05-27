include_recipe 'opentsdb::java'

package 'gnuplot'

package_path = "#{Chef::Config['file_cache_path']}/opentsdb.deb"

remote_file 'opentsdb_package' do
  backup   false
  checksum node['opentsdb']['package_checksum']
  path     package_path
  source   node['opentsdb']['package_url']
end

dpkg_package 'opentsdb' do
  source package_path
end

link '/usr/bin/tsdb' do
  to '/usr/share/opentsdb/bin/tsdb'
end

chef_gem 'java-properties' do
  version '0.0.2'
end

require 'java-properties'

template '/etc/opentsdb/opentsdb.conf' do
  helpers(JavaPropertiesHelper)
  source 'opentsdb.conf.erb'
  notifies :restart, 'service[opentsdb]'
end

service 'opentsdb' do
  action [:enable, :start]
  supports :status => true, :restart => true
end

execute 'create_opentsdb_tables' do
  command 'sh /usr/share/opentsdb/tools/create_table.sh'
  creates "#{node['hbase']['root_dir']}/tsdb"
  env(
    'HBASE_HOME' => '/usr/lib/hbase',
    'COMPRESSION' => node['opentsdb']['compression'])
  timeout 60
  only_if { node['opentsdb']['create_tables'] }
end
