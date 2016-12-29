# frozen_string_literal: true
ENV['RACK_ENV'] = 'test'

require 'everypolitician'
require 'minitest/autorun'
require 'nokogiri'
require 'pry'
require 'rack/test'
require 'webmock/minitest'

module Minitest
  class Spec
    include Rack::Test::Methods

    def app
      Sinatra::Application
    end

    before do
      stub_request(:get, DATASOURCE).to_return(body: countries_json)
    end

    def new_tempfile(contents, filename = 'sye-tests')
      Tempfile.open([filename, '.md']) do |f|
        f.write(contents)
        f.path
      end
    end

    private

    DATASOURCE = 'https://github.com/everypolitician/everypolitician-data/raw/master/countries.json'
    DISK_PATH = 'tests/fixtures/ep_data'
    COUNTRIES_SHA = 'd8a4682'

    def countries_json
      @countries_json ||= File.read("#{DISK_PATH}/#{COUNTRIES_SHA}/countries.json")
    end
  end
end
