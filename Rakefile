# encoding: utf-8

require 'rubygems'
require 'rake'

begin
  gem 'rubygems-tasks', '~> 0.2'
  require 'rubygems/tasks'

  Gem::Tasks.new
rescue LoadError => e
  warn e.message
  warn 'Run `gem install rubygems-tasks` to install Gem::Tasks.'
end

begin
  gem 'rdoc', '~> 4.1'
  require 'rdoc/task'

  RDoc::Task.new do |rdoc|
    rdoc.title = 'trange_frange'
  end
rescue LoadError => e
  warn e.message
  warn "Run `gem install rdoc` to install 'rdoc/task'."
end
task :doc => :rdoc

begin
  gem 'rspec', '~> 3.1'
  require 'rspec/core/rake_task'

  RSpec::Core::RakeTask.new
rescue LoadError => e
  task :spec do
    abort 'Please run `gem install rspec` to install RSpec.'
  end
end

task :test    => :spec
task :default => :spec
