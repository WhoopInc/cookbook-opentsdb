#
# Cookbook Name:: opentsdb
# Recipe:: default
#
# Copyright (C) 2013 Whoop, Inc.
# 
# All rights reserved - Do Not Redistribute
#

node.default['java']['oracle']['accept_oracle_download_terms'] = true

include_recipe 'java::oracle'

ENV['JAVA_HOME'] = node[:java][:java_home]
ENV['HBASE_HOME'] = '/usr/lib/hbase'

ruby_block 'add env vars to etc/environment' do
  block do
    rc = Chef::Util::FileEdit.new("/etc/environment")
    rc.insert_line_if_no_match(/^JAVA_HOME/, %[JAVA_HOME="#{ENV['JAVA_HOME']}"])
    rc.write_file

    rc = Chef::Util::FileEdit.new("/etc/environment")
    rc.insert_line_if_no_match(/^HBASE_HOME/, %[HBASE_HOME="#{ENV['HBASE_HOME']}"])
    rc.write_file
  end
end


##
# Hadoop and HBase
##

apt_repository 'cloudera' do
  uri 'http://archive.cloudera.com/cdh4/ubuntu/precise/amd64/cdh'
  distribution "#{node['lsb']['codename']}-cdh4"
  components ['contrib']
  key 'http://archive.cloudera.com/cdh4/ubuntu/precise/amd64/cdh/archive.key'
  arch 'amd64'
  deb_src true
  action :add
end

apt_repository 'cloudera_gplextras' do
  uri 'http://archive.cloudera.com/gplextras/ubuntu/precise/amd64/gplextras/'
  distribution "#{node['lsb']['codename']}-gplextras4"
  components ['contrib']
  key 'http://archive.cloudera.com/gplextras/ubuntu/precise/amd64/gplextras/archive.key'
  arch 'amd64'
  deb_src true
  action :add
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

cookbook_file '/etc/hadoop/conf/core-site.xml' do
  action :create
  source 'core-site.xml'
end

cookbook_file '/etc/hadoop/conf/hdfs-site.xml' do
  action :create
  source 'hdfs-site.xml'
end

cookbook_file '/etc/hbase/conf/hbase-site.xml' do
  action :create
  source 'hbase-site.xml'
end

cookbook_file '/etc/hbase/conf/hbase-env.sh' do
  action :create
  source 'hbase-env.sh'
end

service 'hbase-master' do
  action :start
  supports status: true, restart: true
end


##
# OpenTSDB
##

package 'gnuplot'

cookbook_file 'opentsdb-2.0.0.deb' do
  action :create
  path "/tmp/opentsdb.deb"
end

dpkg_package 'opentsdb' do
  action :install
  version '2.0.0-rc1'
  source '/tmp/opentsdb.deb'
end

user 'opentsdb' do
  action :manage
  shell '/bin/bash'
end

link '/usr/local/bin/tsdb' do
  to '/usr/share/opentsdb/bin/tsdb'
end

execute 'sh /usr/share/opentsdb/bin/create_table.sh'

service 'opentsdb' do
  action :start
  supports status: true, restart: true
end
