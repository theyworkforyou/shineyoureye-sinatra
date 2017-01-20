# frozen_string_literal: true
source 'https://rubygems.org'

# Update README if this version is updated
ruby '2.3.1'

git_source(:github) { |repo_name| "https://github.com/#{repo_name}.git" }

gem 'compass'
gem 'everypolitician', '~> 0.20.0', github: 'everypolitician/everypolitician-ruby'
gem 'nokogiri', '>= 1.6.7'
gem 'rake'
gem 'rdiscount'
gem 'sinatra'

group :test do
  gem 'minitest'
  gem 'pry'
  gem 'rack-test'
  gem 'webmock'
end
