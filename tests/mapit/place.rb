# frozen_string_literal: true

require 'test_helper'
require_relative '../../lib/mapit/place'

describe 'Place' do
  describe 'when area has a parent' do
    let(:place) do
      Mapit::Place.new(
        mapit_area_data: area_with_parent,
        pombola_slug: 'kuje-abaji-gwagwalada-kwali',
        baseurl: '/baseurl/',
        parent: Mapit::Place.new(
          mapit_area_data: area_with_no_parent,
          pombola_slug: 'federal-capital-territory',
          baseurl: '/baseurl/'
        )
      )
    end

    it 'knows its id' do
      place.id.must_equal(918)
    end

    it 'knows its name' do
      place.name.must_equal('BATAGARAWA/RIMI/CHARANCHI')
    end

    it 'knows its parent name' do
      place.parent.name.must_equal('Federal Capital Territory')
    end

    it 'builds the place url with the baseurl' do
      place.url.must_equal('/baseurl/kuje-abaji-gwagwalada-kwali/')
    end

    it 'builds the parent url with the baseurl' do
      place.parent.url.must_equal('/baseurl/federal-capital-territory/')
    end

    it 'knows its type' do
      place.type_name.must_equal('Federal Constituency')
    end

    it 'knows it is a child' do
      assert(place.child_area?)
    end

    it 'the parent returns nil for its parent' do
      assert_nil(place.parent.parent)
    end

    it 'the parent knows it is not a child' do
      refute(place.parent.child_area?)
    end

    describe '#state' do
      it 'returns the parent object if that is a state' do
        place.parent.type_name.must_equal('State')
        place.state.must_equal(place.parent)
      end
    end
  end

  describe 'state with no parent' do
    let(:place) do
      Mapit::Place.new(
        mapit_area_data: area_with_no_parent,
        pombola_slug: 'kuje-abaji-gwagwalada-kwali',
        baseurl: '/baseurl/'
      )
    end

    describe '#state' do
      it 'returns the current object' do
        place.type_name.must_equal('State')
        place.state.must_equal(place)
      end
    end
  end

  describe 'area with no thumbnail image' do
    let(:place) do
      Mapit::Place.new(
        mapit_area_data: area_with_no_parent,
        pombola_slug: 'kuje-abaji-gwagwalada-kwali',
        baseurl: '/baseurl/'
      )
    end

    it 'has default "pin" thumbnail_url' do
      place.thumbnail_url.must_equal('/images/place-250x250.png')
    end
  end

  describe 'area with thumbnail image' do
    let(:place) do
      Mapit::Place.new(
        mapit_area_data: area_with_no_parent,
        pombola_slug: 'federal-capital-territory',
        baseurl: '/baseurl/'
      )
    end

    it 'has custom image thumbnail_url' do
      place.thumbnail_url.must_equal('/images/thumbnails/federal-capital-territory.jpg')
    end
  end

  def area_with_parent
    parsed_mapit_data_for_area_type('FED').values.first
  end

  def area_with_no_parent
    parsed_mapit_data_for_area_type('STA')['16']
  end
end
