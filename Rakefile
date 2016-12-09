# frozen_string_literal: true
require 'rake/testtask'

Rake::TestTask.new do |t|
  t.name = 'test:doc'
  t.warning = true
  t.description = 'Run "Document" tests'
  t.test_files = FileList['tests/document/*.rb']
  t.libs << 'tests'
end

Rake::TestTask.new do |t|
  t.name = 'test:web'
  t.warning = true
  t.description = 'Run "Web" tests'
  t.test_files = FileList['tests/web/*.rb']
  t.libs << 'tests'
end

