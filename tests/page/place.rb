# frozen_string_literal: true

require 'test_helper'
require_relative '../../lib/page/place'
require_relative '../../lib/mapit/coordinate'

describe 'Page::Place' do
  let(:page) do
    Page::Place.new(
      place: FakePlace.new(1, 'Abaji/Gwagwalada/Kwali/Kuje'),
      people_by_legislature: FakePeople.new('House of Representatives'),
      geometry: FakeGeometry.new('geoJSON', Mapit::Coordinate.new(1, 2))
    )
  end

  it 'has a title' do
    page.title.must_equal('Abaji/Gwagwalada/Kwali/Kuje')
  end

  it 'has a social media share name' do
    page.share_name.must_equal('Abaji/Gwagwalada/Kwali/Kuje')
  end

  it 'has a place' do
    page.place.id.must_equal(1)
  end

  it 'has a list of people for that place' do
    page.people.count.must_equal(2)
  end

  describe 'when asking for the legislature name' do
    it 'has one for child areas' do
      page.legislature_name.must_equal('(House of Representatives)')
    end

    it 'has none for parent areas' do
      page = Page::Place.new(
        place: FakePlace.new(1, 'Abia'),
        people_by_legislature: FakePeople.new(nil),
        geometry: 'irrelevant'
      )
      page.legislature_name.must_equal('')
    end
  end

  it 'has the geoJSON feature for that place' do
    page.geojson.must_equal('geoJSON')
  end

  it 'has the center coordinates of the place' do
    page.center.must_equal([1, 2])
  end

  FakeGeometry = Struct.new(:geojson, :center)
  FakePeople = Struct.new(:legislature_name) do
    def find_all_by_mapit_area(_)
      %w(irrelevant irrelevant)
    end
  end
end
