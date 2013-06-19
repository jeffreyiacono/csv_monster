#!/usr/bin/env rake
require "bundler/gem_tasks"
begin
  require 'rspec/core/rake_task'

  RSpec::Core::RakeTask.new(:spec) do |t|
    t.rspec_opts = '-b'
  end

  task default: :spec
rescue LoadError
  $stderr.puts "rspec not available, spec task not provided"
end
