# frozen_string_literal: true

require_relative 'coordinate'
require 'net/http'

module Mapit
  class Geometry
    def initialize(geojson_url:, geometry_url:, user_agent:)
      @geojson_url = geojson_url
      @geometry_url = geometry_url
      @user_agent = user_agent
    end

    def geojson
      @geojson ||= get(geojson_url)
    end

    def center
      @geometry ||= JSON.parse(get(geometry_url))
      Coordinate.new(@geometry['centre_lat'], @geometry['centre_lon'])
    end

    private

    attr_reader :geojson_url, :geometry_url, :user_agent

    def get(url)
      response = http(URI(url)).request(request(URI(url)))
      raise_if_response_not_ok(url, response.code)
      response.body
    end

    def http(uri)
      Net::HTTP.start(uri.host, uri.port, use_ssl: true)
    end

    def request(uri)
      headers = { 'User-Agent' => user_agent } if user_agent
      Net::HTTP::Get.new(uri.request_uri, headers)
    end

    def raise_if_response_not_ok(url, status_code)
      raise "No geometry data for '#{url}'" unless status_code == '200'
    end
  end
end
