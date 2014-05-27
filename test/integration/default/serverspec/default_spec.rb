require 'serverspec'

include Serverspec::Helper::Exec
include Serverspec::Helper::DetectOS

describe service('opentsdb') do
  it { should be_running }
end

describe port(4242) do
  it { should be_listening }
end

command('tsdb') do
  it { should return_stdout(/usage: tsdb/) }
  it { should return_exit_status 0 }
end
