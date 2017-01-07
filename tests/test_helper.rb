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
      get_from_disk(DATASOURCE, countries_json)
      get_from_disk(assembly_json_url, assembly_json)
    end

    def new_tempfile(contents, filename = 'sye-tests')
      Tempfile.open([filename, '.md']) do |f|
        f.write(contents)
        f.path
      end
    end

    private

    DATASOURCE = 'https://github.com/everypolitician/everypolitician-data/raw/master/countries.json'
    REPO_URL = 'https://cdn.rawgit.com/everypolitician/everypolitician-data'
    DISK_PATH = 'tests/fixtures/ep_data'
    COUNTRIES_SHA = 'd8a4682'
    ASSEMBLY_SHA = '75b7651'

    def get_from_disk(url, json_file)
      stub_request(:get, url).to_return(body: json_file)
    end

    def assembly_json_url
      "#{REPO_URL}/#{ASSEMBLY_SHA}/data/Nigeria/Assembly/ep-popolo-v1.0.json"
    end

    def countries_json
      @countries_json ||= File.read("#{DISK_PATH}/#{COUNTRIES_SHA}/countries.json")
    end

    def assembly_json
      @assembly_json ||= File.read("#{DISK_PATH}/#{ASSEMBLY_SHA}/ep-popolo-v1.0.json")
    end
  end
end
