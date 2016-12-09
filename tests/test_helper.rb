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

    def new_file(contents)
      file = Tempfile.new(['foo', '.md'])
      file.write(contents)
      file.close
      file
    end
  end
end
