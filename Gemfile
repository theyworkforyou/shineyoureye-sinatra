# frozen_string_literal: true

source 'https://rubygems.org'

# Warning: update the README, .travis.yml and TargetRubyVersion in .rubocop.yml
# if this version is changed:
ruby '2.3.1'

git_source(:github) { |repo_name| "https://github.com/#{repo_name}.git" }

gem 'bootstrap-sass'
gem 'coveralls', require: false
gem 'everypolitician', '~> 0.20.0', github: 'everypolitician/everypolitician-ruby'
gem 'nokogiri', '>= 1.6.7'
gem 'rake'
gem 'rdiscount'
gem 'sass'
gem 'sinatra'
gem 'sinatra-contrib', require: 'sinatra/content_for'

group :test do
  gem 'minitest'
  gem 'pry'
  gem 'rack-test'
  gem 'rubocop'
  gem 'webmock'
end
