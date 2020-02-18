# frozen_string_literal: true

require 'test_helper'
require_relative '../../lib/mapit/geometry'

describe 'Mapit::Geometry' do
  let(:geometry) do
    Mapit::Geometry.new(
      geojson_url: geojson_json_url(949),
      geometry_url: geometry_json_url(949),
      user_agent: 'Test'
    )
  end

  before do
    get_from_disk(geojson_json_url(949), geojson_json)
    get_from_disk(geometry_json_url(949), geometry_json)
  end

  it 'gets a geoJSON feature as a polygon' do
    geojson = JSON.parse(geometry.geojson)
    geojson['type'].must_equal('Polygon')
  end

  it 'gets a geoJSON feature with the coordinates' do
    geojson = JSON.parse(geometry.geojson)
    geojson['coordinates'].first.count.must_equal(254)
  end

  it 'gets the coordinates of the center of an area' do
    geometry.center.latitude.must_equal(8.774458149655636)
    geometry.center.longitude.must_equal(7.02805574434006)
  end

  it 'raises an error if response status is not OK' do
    bad_url = 'https://notfound.com'
    stub_request(:get, bad_url).to_return(status: 404)
    geometry = Mapit::Geometry.new(geojson_url: bad_url, geometry_url: 'irrelevant', user_agent: 'irrelevant')

    error = assert_raises(RuntimeError) { geometry.geojson }
    error.message.must_include(bad_url)
  end

  describe 'custom user agent header' do
    it 'uses it if specified' do
      geometry.center
      assert_requested(:get, geometry_json_url(949), headers: { 'User-Agent' => 'Test' })
    end

    it 'does not set it, if it is not specified' do
      url = geojson_json_url(949)
      geometry = Mapit::Geometry.new(geojson_url: url, geometry_url: 'irrelevant', user_agent: nil)
      geometry.geojson
      assert_requested(:get, url, headers: { 'User-Agent' => 'Ruby' })
    end
  end
end
