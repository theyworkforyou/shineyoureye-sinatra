# frozen_string_literal: true
require 'test_helper'
require_relative '../../lib/ep/people_by_legislature'
require_relative '../../lib/membership_csv/people'
require_relative '../../lib/page/places'

describe 'Page::Places' do
  let(:people) do
    EP::PeopleByLegislature.new(
      legislature: nigeria_at_known_revision.legislature('Representatives'),
      person_factory: FakePersonFactory.new(FakeMapit.new(1))
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

  describe 'when places are parent areas' do
    let(:contents) do
      'id,name,identifier__shineyoureye,phone
id1,name1,name-1,1234
id2,name2,name-2,5678
id3,name3,name-3,'
    end
    let(:people) do
      MembershipCSV::People.new(
        csv_filename: new_tempfile(contents),
        person_factory: FakePersonFactory.new(FakeMapit.new(1))
      )
    end
    let(:page) do
      Page::Places.new(
        title: 'States',
        places: %w(irrelevant irrelevant),
        people_by_legislature: people
      )
    end

    it 'does not have a legislature name' do
      assert_nil(page.legislature_name)
    end

    it 'does not know the current term year' do
      assert_nil(page.current_term_start_year)
    end
  end
end
