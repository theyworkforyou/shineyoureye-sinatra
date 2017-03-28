# frozen_string_literal: true
require 'test_helper'
require_relative '../../lib/ep/people_by_legislature'
require_relative '../shared_examples/people_interface_test'

describe 'EP::PeopleByLegislature' do
  let(:legislature) { nigeria_at_known_revision.legislature('Representatives') }

  describe 'non-mapit methods' do
    include PeopleInterfaceTest

    let(:people) do
      EP::PeopleByLegislature.new(
        legislature: legislature,
        mapit: 'irrelevant',
        baseurl: '/baseurl/',
        identifier_scheme: 'shineyoureye'
      )
    end

    it 'has a list of all the people' do
      people.find_all.count.must_equal(364)
    end

    it 'has people from the current term' do
      people.find_all.first.memberships.first.legislative_period.id.must_equal('term/8')
    end

    it 'sorts people by name' do
      (people.find_all.first.name < people.find_all.last.name).must_equal(true)
    end

    it 'people are person objects' do
      people.find_all.first.id.must_equal('b2a7f72a-9ecf-4263-83f1-cb0f8783053c')
    end

    it 'uses the baseurl in the person url' do
      people.find_all.first.url.must_equal('/baseurl/b2a7f72a-9ecf-4263-83f1-cb0f8783053c/')
    end

    it 'finds a single person by id' do
      people.find_single('b2a7f72a-9ecf-4263-83f1-cb0f8783053c').name
            .must_equal('ABDUKADIR RAHIS')
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
  end

  describe 'extra mapit functionality' do
    let(:people) do
      EP::PeopleByLegislature.new(
        legislature: legislature,
        mapit: FakeMapit.new(1),
        baseurl: '/baseurl/',
        identifier_scheme: 'shineyoureye'
      )
    end

    it 'assigns a mapit area to the person' do
      people.find_single('b2a7f72a-9ecf-4263-83f1-cb0f8783053c').area.id
            .must_equal(1)
    end

    it 'finds all people in a mapit area' do
      people.find_all_by_mapit_area(1).count.must_equal(364)
    end
  end
end
