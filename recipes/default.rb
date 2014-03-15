ENV['HBASE_HOME'] = '/usr/lib/hbase'

ruby_block 'add env vars to etc/environment' do
  block do
    rc = Chef::Util::FileEdit.new('/etc/environment')
    rc.insert_line_if_no_match(/^HBASE_HOME/, %(HBASE_HOME="#{ENV['HBASE_HOME']}"))
    rc.write_file
  end
end

include_recipe 'opentsdb::hbase'
include_recipe 'opentsdb::opentsdb'
