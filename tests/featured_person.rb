# frozen_string_literal: true

require 'test_helper'
require_relative '../lib/featured_person'

describe 'FeaturedPerson' do
  let(:page_fragment) do
    PageFragment::FeaturedPerson.new(
      FakePerson.new(nil, 'Name'),
      'Senators',
      '/url/to/list/of/senators/'
    )
  end

  it 'has a featured person' do
    page_fragment.featured_person.name.must_equal('Name')
  end

  it 'has a display text for the person type' do
    page_fragment.people_type_display_text.must_equal('Senators')
  end

  it 'has a url to the list of people of that type' do
    page_fragment.people_type_url.must_equal('/url/to/list/of/senators/')
  end
end
