require 'spec_helper'

class JavaPropertiesHelperHarness
  include JavaPropertiesHelper
end

describe(JavaPropertiesHelper) do
  before do
    JavaProperties.stub(:generate) { |x| x }
  end

  it 'should convert arrays to comma-separated lists' do
    properties = JavaPropertiesHelperHarness.new.generate_properties(
      'zk_ips' => ['8.8.8.8', '8.8.4.4'],
      'bool' => false,
      'string' => true
    )

    expect(properties).to eq(
      'zk_ips' => '8.8.8.8,8.8.4.4',
      'bool' => false,
      'string' => true
    )
  end
end
