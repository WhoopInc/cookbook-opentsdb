require 'spec_helper'

describe 'opentsdb::hbase' do
  let(:chef_run) do
    ChefSpec::Runner.new do |node|
      node.set['hbase']['conf_dir'] = 'conf.benesch'
      node.set['hbase']['root_dir'] = '/i/love/fun'
    end.converge(described_recipe)
  end

  it 'installs hbase' do
    expect(chef_run).to install_package('hbase')
  end

  it 'installs hbase-master' do
    expect(chef_run).to install_package('hbase-master')
  end

  it 'adds the cloudera apt repository' do
    expect(chef_run).to add_apt_repository('cloudera_cdh')
  end

  context 'when lzo_compression is enabled' do
    before(:each) do
      chef_run.node.set['hbase']['lzo_compression'] = true
      chef_run.converge(described_recipe)
    end

    it 'installs lzop' do
      expect(chef_run).to install_package('lzop')
    end

    it 'installs hadoop-lzo-cdh4' do
      expect(chef_run).to install_package('hadoop-lzo-cdh4')
    end

    it 'adds the cloudera-gplextras apt repository' do
      expect(chef_run).to add_apt_repository('cloudera_gplextras')
    end

    it 'configures hbase to verify lzo compression is working' do
      expect(chef_run).to render_file('/etc/hbase/conf.benesch/hbase-site.xml').with_content(
        have_xpath("/configuration/property[name='hbase.regionserver.codecs' and value='lzo']")
      )
    end
  end

  context 'when lzo_compression is disabled' do
    before(:each) do
      chef_run.node.set['hbase']['lzo_compression'] = false
      chef_run.converge(described_recipe)
    end

    it 'does not install lzop' do
      expect(chef_run).to_not install_package('lzop')
    end

    it 'does not install hadoop-lzo-cdh4' do
      expect(chef_run).to_not install_package('hadoop-lzo-cdh4')
    end

    it 'does not add the cloudera-gplextras apt repository' do
      expect(chef_run).to_not add_apt_repository('cloudera_gplextras')
    end
  end

  it 'sets the nofile limit for the hbase process' do
    chef_run.node.set['hbase']['nofile'] = 12_345
    chef_run.converge(described_recipe)
    expect(chef_run).to render_file('/etc/default/hbase')
      .with_content(/ulimit -n 12345/)
  end

  it 'sets the nproc limit for the hbase process' do
    chef_run.node.set['hbase']['nproc'] = 12_345
    chef_run.converge(described_recipe)
    expect(chef_run).to render_file('/etc/default/hbase')
      .with_content(/ulimit -u 12345/)
  end

  it 'creates the directory' do
    expect(chef_run).to create_directory('/i/love/fun')
  end

  it 'configures hbase.rootdir to point to the directory' do
    expect(chef_run).to render_file('/etc/hbase/conf.benesch/hbase-site.xml').with_content(
      have_xpath("/configuration/property[name='hbase.rootdir' and value='file:///i/love/fun']")
    )
  end

  it 'creates /etc/default/hbase' do
    expect(chef_run).to create_template('/etc/default/hbase')
  end

  it 'restarts hbase-master when /etc/default/hbase changes' do
    resource = chef_run.template('/etc/default/hbase')
    expect(resource).to notify('service[hbase-master]').to(:restart)
  end

  it 'creates hbase-site.xml' do
    expect(chef_run).to create_template('/etc/hbase/conf.benesch/hbase-site.xml')
  end

  it 'restarts hbase-master when hbase-site.xml changes' do
    resource = chef_run.template('/etc/hbase/conf.benesch/hbase-site.xml')
    expect(resource).to notify('service[hbase-master]')
  end

  it 'updates alternatives' do
    expect(chef_run).to run_execute('update_hbase_conf_alternatives')
  end

  it 'starts the hbase-master service' do
    expect(chef_run).to start_service('hbase-master')
  end
end
