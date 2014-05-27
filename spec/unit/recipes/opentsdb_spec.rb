require 'spec_helper'

describe 'opentsdb::opentsdb' do
  let(:chef_run) do
    ChefSpec::Runner.new do |node|
      node.set['opentsdb']['package_checksum'] = 'notachecksum'
      node.set['opentsdb']['package_url'] = 'https://not.real/package.deb'
      node.set['opentsdb']['config'] = {
        'canary' => 'config'
      }
    end.converge(described_recipe)
  end

  it 'installs java' do
    expect(chef_run).to include_recipe('opentsdb::java')
  end

  it 'installs gnuplot' do
    expect(chef_run).to install_package('gnuplot')
  end

  it 'downloads opentsdb from configured package_url' do
    expect(chef_run).to create_remote_file('opentsdb_package').with(
      :source => 'https://not.real/package.deb',
      :checksum => 'notachecksum')
  end

  it 'installs opentsdb from package' do
    expect(chef_run).to install_dpkg_package('opentsdb')
  end

  it 'links tsdb cli into /usr/bin' do
    expect(chef_run).to create_link('/usr/bin/tsdb')
  end

  it 'creates configuration file' do
    expect(chef_run).to create_template('/etc/opentsdb/opentsdb.conf')
  end

  it 'writes out arbitrary configuration key values' do
    expect(chef_run).to render_file('/etc/opentsdb/opentsdb.conf')
      .with_content(/^canary=config$/)
  end

  it 'installs java-properties gem' do
    expect(chef_run).to install_chef_gem('java-properties')
  end

  it 'restarts opentsdb when configuration changes' do
    resource = chef_run.template('/etc/opentsdb/opentsdb.conf')
    expect(resource).to notify('service[opentsdb]')
  end

  it 'enables opentsdb service' do
    expect(chef_run).to enable_service('opentsdb')
  end

  it 'starts opentsdb service' do
    expect(chef_run).to start_service('opentsdb')
  end

  context('when create_tables is enabled') do
    it 'runs create_table.sh' do
      expect(chef_run).to run_execute('create_opentsdb_tables')
    end
  end

  context('when create_tables is disabled') do
    it 'does not run create_table.sh' do
      expect(chef_run).to run_execute('create_opentsdb_tables')
    end
  end
end
