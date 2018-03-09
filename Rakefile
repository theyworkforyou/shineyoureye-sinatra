# frozen_string_literal: true

require 'rake/testtask'
require 'rubocop/rake_task'

Rake::TestTask.new do |t|
  t.name = 'test'
  t.warning = true
  t.description = 'Run all tests'
  t.test_files = FileList['tests/**/*.rb']
  t.libs << 'tests'
end

RuboCop::RakeTask.new

task default: %w[test rubocop]
