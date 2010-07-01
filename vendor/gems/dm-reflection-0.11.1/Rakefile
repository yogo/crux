require 'rubygems'
require 'rake'
require 'pathname'

begin
  require 'jeweler'
  Jeweler::Tasks.new do |gem|
    gem.name        = %q{dm-reflection}
    gem.summary     = %q{Generates datamapper models from existing database schemas}
    gem.description = %q{Generates datamapper models from existing database schemas and export them to files}
    gem.email       = "irjudson [a] gmail [d] com"
    gem.homepage    = "http://github.com/yogo/dm-reflection"
    gem.authors     = ["Martin Gamsjaeger (snusnu), Yogo Team"]
    gem.add_dependency('dm-core', '~> 0.10.2')
    gem.add_dependency('activesupport')
    gem.add_development_dependency('rspec', ['~> 1.3'])
    gem.add_development_dependency('yard',  ['~> 0.5'])
  end

  Jeweler::GemcutterTasks.new
  FileList['tasks/**/*.rake'].each { |task| import task }
rescue LoadError
  puts "Jeweler (or a dependency) not available. Install it with: gem install jeweler"
end

task :spec => :check_dependencies
task :default => :spec

ROOT    = Pathname(__FILE__).dirname.expand_path
JRUBY   = RUBY_PLATFORM =~ /java/
WINDOWS = Gem.win_platform?
SUDO    = (WINDOWS || JRUBY) ? '' : ('sudo' unless ENV['SUDOLESS'])