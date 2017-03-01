# frozen_string_literal: true
require 'test_helper'
require_relative '../../lib/mapit/place'

describe 'Place' do
  describe 'when area has a parent' do
    let(:place) { Mapit::Place.new(
      mapit_area_data: area_with_parent,
      mapit_ids_to_pombola_slugs: mapit_ids_to_pombola_slugs,
      baseurl: '/baseurl/'
    ) }

    it 'knows its id' do
      place.id.must_equal(949)
    end

    it 'knows its name' do
      place.name.must_equal('Abaji/Gwagwalada/Kwali/Kuje')
    end

    it 'knows its parent name' do
      place.parent_name.must_equal('Federal Capital Territory')
    end

    it 'builds the place url with the baseurl' do
      place.url.must_equal('/baseurl/gwagwaladakuje/')
    end

    it 'builds the parent url with the baseurl' do
      place.parent_url.must_equal('/baseurl/federal-capital-territory/')
    end

    it 'knows its type' do
      place.type_name.must_equal('Federal Constituency')
    end

    it 'knows it is a child' do
      place.is_child_area?.must_equal(true)
    end
  end

  describe 'when area has no parent' do
    let(:place) { Mapit::Place.new(
      mapit_area_data: area_with_no_parent,
      mapit_ids_to_pombola_slugs: mapit_ids_to_pombola_slugs,
      baseurl: '/baseurl/'
    ) }

    it 'returns nil for the parent name' do
      assert_nil(place.parent_name)
    end

    it 'returns nil for the parent url' do
      assert_nil(place.parent_url)
    end

    it 'knows it is not a child' do
      place.is_child_area?.must_equal(false)
    end
  end

  def mapit_ids_to_pombola_slugs
    { '949' => 'gwagwaladakuje', '16' => 'federal-capital-territory' }
  end

  def area_with_parent
    parent = {'parent_id' => 16, 'parent_name' => 'Federal Capital Territory'}
    JSON.parse(FED_JSON).values.first.merge(parent)
  end

  def area_with_no_parent
    JSON.parse(STA_JSON).values.first
  end
end
