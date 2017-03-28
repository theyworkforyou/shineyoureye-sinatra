# frozen_string_literal: true
require 'test_helper'
require_relative '../../lib/ep/people_by_legislature'
require_relative '../../lib/page/places'

describe 'Page::Places' do
  let(:people) do
    EP::PeopleByLegislature.new(
      legislature: nigeria_at_known_revision.legislature('Representatives'),
      mapit: FakeMapit.new(1),
      baseurl: '/baseurl/',
      identifier_scheme: 'shineyoureye'
    )
  end
  let(:page) do
    Page::Places.new(
      title: 'Constituencies',
      places: %w(irrelevant irrelevant),
      people_by_legislature: people
    )
  end

  it 'has a title' do
    page.title.must_equal('Constituencies')
  end

  it 'has all areas' do
    page.places.count.must_equal(2)
  end

  it 'knows the legislature name' do
    page.legislature_name.must_equal('House of Representatives')
  end

  it 'knows the current term year' do
    page.current_term_start_year.must_equal(2015)
  end
end
