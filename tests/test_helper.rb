# frozen_string_literal: true
ENV['RACK_ENV'] = 'test'

require 'everypolitician'
require 'minitest/autorun'
require 'nokogiri'
require 'rack/test'
require 'pry'

module Minitest
  class Spec
    include Rack::Test::Methods

    def app
      Sinatra::Application
    end

    def new_tempfile(contents, filename = 'sye-tests')
      Tempfile.open([filename, '.md']) do |f|
        f.write(contents)
        f.path
      end
    end
  end
end
