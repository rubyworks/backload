#!/usr/bin/env ruby

task :default => [:test]

desc "Run unit tests."
task :test do
  sh "rubytest -Ilib test/test_*"
end
