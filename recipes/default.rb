node.set['java']['oracle']['accept_oracle_download_terms'] = true

include_recipe 'java::oracle'

ENV['JAVA_HOME'] = node['java']['java_home']
ENV['HBASE_HOME'] = '/usr/lib/hbase'

ruby_block 'add env vars to etc/environment' do
  block do
    rc = Chef::Util::FileEdit.new('/etc/environment')
    rc.insert_line_if_no_match(/^JAVA_HOME/, %(JAVA_HOME="#{ENV['JAVA_HOME']}"))
    rc.write_file

    rc = Chef::Util::FileEdit.new('/etc/environment')
    rc.insert_line_if_no_match(/^HBASE_HOME/, %(HBASE_HOME="#{ENV['HBASE_HOME']}"))
    rc.write_file
  end
end

include_recipe 'opentsdb::add_cloudera_repo'
include_recipe 'opentsdb::install_hbase'
include_recipe 'opentsdb::install_opentsdb'
