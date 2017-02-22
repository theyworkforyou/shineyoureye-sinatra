# frozen_string_literal: true

require 'coveralls'
Coveralls.wear!

ENV['RACK_ENV'] = 'test'

require 'everypolitician'
require 'minitest/autorun'
require 'nokogiri'
require 'pry'
require 'rack/test'
require 'webmock/minitest'

require_relative '../lib/document/markdown_with_frontmatter'
require_relative './fixtures/mapit_data'
require_relative './test_doubles'

module Minitest
  class Spec
    include Rack::Test::Methods

    def app
      # Some resources are requested from MapIt's API at the start of
      # app.rb, so we only require app.rb here, after the stubbing of
      # requests has been set up - otherwise it will try to make real
      # requests to the API when running tests.
      require_relative '../app'
      Sinatra::Application
    end

    before do
      get_from_disk(DATASOURCE, countries_json)
      get_from_disk(reps_json_url, reps_json)
      get_from_disk(senate_json_url, senate_json)
      get_from_disk("#{mapit_url}STA", STA_JSON)
      get_from_disk("#{mapit_url}FED", FED_JSON)
      get_from_disk("#{mapit_url}SEN", SEN_JSON)
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

    def mapit_url
      'http://nigeria.mapit.mysociety.org/areas/'
    end

    def nigeria_at_known_revision
      @ng ||= EveryPolitician::Index.new(index_url: DATASOURCE).country('Nigeria')
    end

    private

    DATASOURCE = 'https://github.com/everypolitician/everypolitician-data/raw/master/countries.json'
    REPO_URL = 'https://cdn.rawgit.com/everypolitician/everypolitician-data'
    DISK_PATH = 'tests/fixtures/ep_data'
    COUNTRIES_COMMIT = '62e6190'
    REPS_COMMIT = 'd5a1eb7'
    SENATE_COMMIT = '9b61497'

    def get_from_disk(url, json_file)
      stub_request(:get, url).to_return(body: json_file)
    end

    def reps_json_url
      "#{REPO_URL}/#{REPS_COMMIT}/data/Nigeria/Representatives/ep-popolo-v1.0.json"
    end

    def senate_json_url
      "#{REPO_URL}/#{SENATE_COMMIT}/data/Nigeria/Senate/ep-popolo-v1.0.json"
    end

    def countries_json
      @countries_json ||= File.read("#{DISK_PATH}/#{COUNTRIES_COMMIT}/countries.json")
    end

    def reps_json
      @reps_json ||= File.read("#{DISK_PATH}/#{REPS_COMMIT}/ep-popolo-v1.0.json")
    end

    def senate_json
      @senate_json ||= File.read("#{DISK_PATH}/#{SENATE_COMMIT}/ep-popolo-v1.0.json")
    end
  end
end
