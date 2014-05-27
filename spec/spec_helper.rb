require 'chefspec'
require 'chefspec/berkshelf'
require 'rspec-xml'

Dir['libraries/*.rb'].each { |f| require File.expand_path(f) }

ChefSpec::Coverage.start!

RSpec.configure do |config|
  config.color_enabled = true
  config.platform = 'ubuntu'
  config.version = '12.04'
end
