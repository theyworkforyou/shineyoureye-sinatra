# frozen_string_literal: true
require_relative 'coordinate'

module Mapit
  class Geometry
    def initialize(geojson_url:, geometry_url:)
      @geojson_url = geojson_url
      @geometry_url = geometry_url
    end

    def geojson
      @geojson ||= get(geojson_url)
    end

    def center
      @geometry ||= JSON.parse(get(geometry_url))
      Coordinate.new(@geometry['centre_lat'], @geometry['centre_lon'])
    end

    private

    attr_reader :geojson_url, :geometry_url

    def get(url)
      response = Net::HTTP.get_response(URI(url))
      raise_if_response_not_ok(url, response.code)
      response.body
    end

    def raise_if_response_not_ok(url, status_code)
      raise "No geometry data for '#{url}'" unless status_code == '200'
    end
  end
end
