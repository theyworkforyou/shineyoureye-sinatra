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
      get_from_disk(reps_json_url, reps_json)
    end

    def new_tempfile(contents, filename = 'sye-tests')
      Tempfile.open([filename, '.md']) do |f|
        f.write(contents)
        f.path
      end
    end

    def basic_document(filename)
      Document::MarkdownWithFrontmatter.new(filename: filename, baseurl: 'irrelevant')
    end

    private

    DATASOURCE = 'https://github.com/everypolitician/everypolitician-data/raw/master/countries.json'
    REPO_URL = 'https://cdn.rawgit.com/everypolitician/everypolitician-data'
    DISK_PATH = 'tests/fixtures/ep_data'
    COUNTRIES_COMMIT = '2dd531c'
    REPS_COMMIT = 'd5a1eb7'

    def get_from_disk(url, json_file)
      stub_request(:get, url).to_return(body: json_file)
    end

    def reps_json_url
      "#{REPO_URL}/#{REPS_COMMIT}/data/Nigeria/Representatives/ep-popolo-v1.0.json"
    end

    def countries_json
      @countries_json ||= File.read("#{DISK_PATH}/#{COUNTRIES_COMMIT}/countries.json")
    end

    def reps_json
      @reps_json ||= File.read("#{DISK_PATH}/#{REPS_COMMIT}/ep-popolo-v1.0.json")
    end
  end
end
