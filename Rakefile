# frozen_string_literal: true
require 'rake/testtask'

Rake::TestTask.new do |t|
  t.name = 'test'
  t.warning = true
  t.description = 'Run all tests'
  t.test_files = FileList['tests/**/*.rb']
  t.libs << 'tests'
end

task default: ['test']
