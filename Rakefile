require "bundler/gem_tasks"
require 'rake/testtask'

task :default => :test

Rake::TestTask.new(:test) do |t|
  puts '*** You should see groups of tests run very quickly (~1s per group).'
  puts '*** If you want to be really safe, run each of the suites individually (listed in .travis.yml).'
  t.pattern = 'spec/**/*spec.rb'
end

namespace :db do

  task :create do
    sh 'createdb minitest_parallel_db'
  end

end
