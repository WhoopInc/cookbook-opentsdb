package 'gnuplot'

cookbook_file 'opentsdb-2.0.0.deb' do
  action :create
  path '/tmp/opentsdb.deb'
end

dpkg_package 'opentsdb' do
  action :install
  version '2.0.0-rc1'
  source '/tmp/opentsdb.deb'
end

template '/etc/opentsdb/opentsdb.conf' do
  action :create
  source 'opentsdb.conf.erb'
end

user 'opentsdb' do
  action :manage
  shell '/bin/bash'
end

link '/usr/local/bin/tsdb' do
  to '/usr/share/opentsdb/bin/tsdb'
end

execute 'sh /usr/share/opentsdb/bin/create_table.sh' do
  # TODO: add not_if
end

service 'opentsdb' do
  action :start
  supports :status => true, :restart => true
end
