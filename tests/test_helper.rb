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
    end

    def geojson_json_url(id)
      "#{MAPIT_URL}/area/#{id}.geojson"
    end

    def geometry_json_url(id)
      "#{MAPIT_URL}/area/#{id}/geometry"
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

    def nigeria_at_known_revision
      @nigeria_at_known_revision ||= EveryPolitician::Index.new(index_url: DATASOURCE).country('Nigeria')
    end

    def mapit_data_for_area_type(area_type)
      json_filename = File.join(
        File.dirname(__FILE__), '..', 'mapit', "#{area_type}.json"
      )
      open(json_filename, &:read)
    end

    def parsed_mapit_data_for_area_type(area_type)
      JSON.parse(mapit_data_for_area_type(area_type))
    end

    private

    DATASOURCE = 'https://github.com/everypolitician/everypolitician-data/raw/master/countries.json'
    REPO_URL = 'https://cdn.rawgit.com/everypolitician/everypolitician-data'
    MAPIT_URL = 'http://nigeria.mapit.mysociety.org'

    EP_DISK_PATH = 'tests/fixtures/ep_data'
    MAPIT_DISK_PATH = 'tests/fixtures/mapit_data'

    COUNTRIES_COMMIT = 'd96d2be'
    REPS_COMMIT = '1e00ca8'
    SENATE_COMMIT = '99f866a'

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
      @countries_json ||= File.read("#{EP_DISK_PATH}/#{COUNTRIES_COMMIT}/countries.json")
    end

    def reps_json
      @reps_json ||= File.read("#{EP_DISK_PATH}/#{REPS_COMMIT}/ep-popolo-v1.0.json")
    end

    def senate_json
      @senate_json ||= File.read("#{EP_DISK_PATH}/#{SENATE_COMMIT}/ep-popolo-v1.0.json")
    end

    def geojson_json
      @geojson_json ||= File.read("#{MAPIT_DISK_PATH}/949.geojson.json")
    end

    def geometry_json
      @geometry_json ||= File.read("#{MAPIT_DISK_PATH}/geometry.json")
    end
  end
end
