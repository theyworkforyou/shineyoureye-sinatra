# frozen_string_literal: true
require 'test_helper'
require_relative '../../lib/ep/people_by_legislature'
require_relative '../../lib/mapit/place'
require_relative '../../lib/page/place'

describe 'Page::Place' do
  let(:place) { Mapit::Place.new(
    mapit_area_data: area_with_parent,
    pombola_slug: 'gwagwaladakuje',
    baseurl: '/baseurl/'
  ) }
  let(:people) { EP::PeopleByLegislature.new(
    legislature: nigeria_at_known_revision.legislature('Representatives'),
    mapit: FakeMapit.new(949),
    baseurl: '/baseurl/'
  ) }
  let(:page) { Page::Place.new(
    place: place,
    people_by_legislature: people,
    people_path: '/people/'
  ) }

  it 'has a title' do
    page.title.must_equal('Abaji/Gwagwalada/Kwali/Kuje')
  end

  it 'has a social media share name' do
    page.share_name.must_equal('Abaji/Gwagwalada/Kwali/Kuje')
  end

  it 'has a place with an id' do
    page.place.id.must_equal(949)
  end

  it 'has a place with a name' do
    page.place.name.must_equal('Abaji/Gwagwalada/Kwali/Kuje')
  end

  it 'has a place with a type_name' do
    page.place.type_name.must_equal('Federal Constituency')
  end

  it 'has a place with a url' do
    page.place.url.must_equal('/baseurl/gwagwaladakuje/')
  end

  it 'has a key figure associated with the place' do
    assert_nil(page.key_figure)
  end

  it 'has all the people for that place' do
    page.people.count.must_equal(364)
  end

  it 'knows the legislature name' do
    page.legislature_name.must_equal('House of Representatives')
  end

  it 'builds the url for the people associated with that place' do
    page.people_url.must_equal('/baseurl/gwagwaladakuje/people/')
  end

  it 'builds the url for the places associated with that place' do
    page.places_url.must_equal('')
  end

  def area_with_parent
    parent = {'parent_id' => 16, 'parent_name' => 'Federal Capital Territory'}
    JSON.parse(FED_JSON).values.first.merge(parent)
  end
end
