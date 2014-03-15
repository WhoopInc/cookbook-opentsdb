require 'spec_helper'

describe 'opentsdb::java' do
  let (:chef_run) { ChefSpec::Runner.new.converge(described_recipe) }

  it 'installs java from the java cookbook' do
    expect(chef_run).to include_recipe('java::default')
  end
end
