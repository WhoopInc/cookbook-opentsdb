require 'serverspec'

include Serverspec::Helper::Exec
include Serverspec::Helper::DetectOS

describe service('hbase-master') do
  it { should be_running }
end

# Log filename depends on username and hostname of hbase user
log_filename = Dir['/var/log/hbase/*-hbase-master*-*.log'].first

describe file(log_filename) do
  it { should be_file }
  its(:content) { should match(/open files.* 12345/) }
  its(:content) { should match(/max user processes.* 7777/) }
end
