# frozen_string_literal: true
require 'test_helper'
require_relative '../shared_examples/people_interface_test'
require_relative '../../lib/ep/people_by_legislature'

describe 'EP::PeopleByLegislature' do
  include PeopleInterfaceTest

  let(:legislature) { nigeria_at_known_revision.legislature('Representatives') }
  let(:people) do
    EP::PeopleByLegislature.new(
      legislature: legislature,
      person_factory: FakePersonFactory.new(FakeMapit.new(1))
    )
  end

  it 'finds all people' do
    people.find_all.count.must_equal(364)
  end

  it 'finds all people sorted by name' do
    (people.find_all.first.name < people.find_all.last.name).must_equal(true)
  end

  it 'finds all people as person objects' do
    people.find_all.first.id.must_equal('b2a7f72a-9ecf-4263-83f1-cb0f8783053c')
  end

  it 'finds a single person by slug' do
    people.find_single('abdullahi-muhammed-wamakko').name.must_equal('ABDULLAHI MOHAMMED')
  end

  it 'returns nothing if a slug is missing' do
    assert_nil(people.find_single('trigger'))
  end

  it 'knows the start date of the current term' do
    people.current_term_start_date.year.must_equal(2015)
    people.current_term_start_date.month.must_equal(6)
    people.current_term_start_date.day.must_equal(9)
  end

  it 'knows its legislature name' do
    people.legislature_name.must_equal('House of Representatives')
  end

  it 'finds a featured person' do
    featured_summaries = [
      FakeSummary.new('b2a7f72a-9ecf-4263-83f1-cb0f8783053c'),
      FakeSummary.new('foo')
    ]
    people.featured_person(featured_summaries).name.must_equal('ABDUKADIR RAHIS')
  end

  it 'returns nil if no featured person' do
    featured_summaries = [FakeSummary.new('foo'), FakeSummary.new('bar')]
    assert_nil(people.featured_person(featured_summaries))
  end

  it 'finds all people in a mapit area' do
    people.find_all_by_mapit_area(1).count.must_equal(364)
  end

  it 'returns nothing if it can not find people in a mapit area' do
    assert_empty(people.find_all_by_mapit_area(0))
  end

  describe 'people in parent area' do
    let(:people) do
      EP::PeopleByLegislature.new(
        legislature: legislature,
        person_factory: FakePersonFactory.new(FakeMapit.new(1, 2))
      )
    end

    it 'finds all people in a parent area' do
      people.find_all_by_mapit_area(2).count.must_equal(364)
    end
  end
end
