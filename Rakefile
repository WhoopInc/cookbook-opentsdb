require 'foodcritic'
require 'rspec/core/rake_task'
require 'rubocop/rake_task'

# Style tests. Rubocop and Foodcritic.
namespace :style do
  desc 'Run Ruby style checks'
  Rubocop::RakeTask.new(:ruby)

  desc 'Run Chef style checks'
  FoodCritic::Rake::LintTask.new(:chef) do |t|
    t.options = {
      :fail_tags => ['any']
    }
  end
end

desc 'Run all style checks'
task :style => ['style:chef', 'style:ruby']

# Rspec and ChefSpec.
desc 'Run ChefSpec examples'
RSpec::Core::RakeTask.new(:spec)

# Integration tests. Test Kitchen.
desc 'Run Test Kitchen integration tests'
task :kitchen do
  # Test Kitchen's built-in rake tasks ignore environment variables, so shell
  # out to the CLI.
  sh 'kitchen test --log-level debug'
end

# Default
task :default => %w(style spec kitchen)
