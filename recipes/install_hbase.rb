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
