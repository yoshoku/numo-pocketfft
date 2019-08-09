require 'bundler/gem_tasks'
require 'rspec/core/rake_task'

RSpec::Core::RakeTask.new(:spec)

require 'rake/extensiontask'

task :build => :compile

Rake::ExtensionTask.new('pocketfftext') do |ext|
  ext.ext_dir = 'ext/numo/pocketfft'
  ext.lib_dir = 'lib/numo/pocketfft'
end

task :default => [:clobber, :compile, :spec]

