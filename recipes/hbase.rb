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

apt_repository 'cloudera_gplextras' do
  uri          "http://archive.cloudera.com/gplextras/ubuntu/#{distro}/amd64/gplextras/"
  distribution "#{node['lsb']['codename']}-gplextras4"
  components   ['contrib']
  key          "http://archive.cloudera.com/gplextras/ubuntu/#{distro}/amd64/gplextras/archive.key"
  arch         'amd64'
  deb_src      true
  action       :add
end

package 'lzop'
package 'hadoop-lzo-cdh4'
package 'hbase'
package 'hbase-master'

directory '/hbase' do
  owner 'hbase'
  group 'hbase'
  mode 0775
end

template '/etc/hadoop/conf/core-site.xml' do
  action :create
  source 'core-site.xml.erb'
end

template '/etc/hadoop/conf/hdfs-site.xml' do
  action :create
  source 'hdfs-site.xml.erb'
end

template '/etc/hbase/conf/hbase-site.xml' do
  action :create
  source 'hbase-site.xml.erb'
  variables :hbase => node[:hbase]
end

template '/etc/hbase/conf/hbase-env.sh' do
  action :create
  source 'hbase-env.sh.erb'
end

service 'hbase-master' do
  action :start
  supports :status => true, :restart => true
end
