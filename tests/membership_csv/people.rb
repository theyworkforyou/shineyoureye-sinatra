# frozen_string_literal: true

require 'test_helper'
require_relative '../shared_examples/people_interface_test'
require_relative '../../lib/membership_csv/people'

describe 'MembershipCSV::People' do
  include PeopleInterfaceTest

  let(:contents) do
    'id,name,identifier__shineyoureye,phone
id1,name1,name-1,1234
id2,name2,name-2,5678
id3,name3,name-3,'
  end
  let(:people) do
    MembershipCSV::People.new(
      csv_filename: new_tempfile(contents),
      legislature: Legislature.new('Governors'),
      person_factory: FakePersonFactory.new(FakeMapit.new(1))
    )
  end

  it 'finds all people' do
    people.find_all.count.must_equal(3)
  end

  it 'finds all people sorted by name' do
    (people.find_all.first.name < people.find_all.last.name).must_equal(true)
  end

  it 'finds all people as person objects' do
    people.find_all.first.id.must_equal('id1')
  end

  it 'returns nil for empty fields' do
    assert_nil(people.find_all.last.phone)
  end

  it 'finds a single person by slug' do
    people.find_single('name-2').name.must_equal('name2')
  end

  it 'throws an exception if a slug is missing' do
    contents = 'id,name,identifier__shineyoureye,phone
id1,name1,,1234'
    people = MembershipCSV::People.new(
      csv_filename: new_tempfile(contents),
      legislature: Legislature.new('Governors'),
      person_factory: FakePersonFactory.new(FakeMapit.new(1))
    )
    error = assert_raises(RuntimeError) { people.find_single('trigger') }
    error.message.must_include('name1')
  end

  it 'throws an exception if a slug is repeated' do
    contents = 'id,name,identifier__shineyoureye,phone
id1,name1,name-1,1234
id2,name2,name-1,5678'
    people = MembershipCSV::People.new(
      csv_filename: new_tempfile(contents),
      legislature: Legislature.new('Governors'),
      person_factory: FakePersonFactory.new(FakeMapit.new(1))
    )
    error = assert_raises(RuntimeError) { people.find_single('name-1') }
    error.message.must_include('name-1')
    error.message.must_include('name1')
    error.message.must_include('name2')
  end

  it 'does not know the start date of the current term' do
    assert_nil(people.current_term_start_date)
  end

  it 'does not know its legislature name' do
    assert_nil(people.legislature_name)
  end

  it 'finds a featured person' do
    featured_summaries = [
      FakeSummary.new('id1'),
      FakeSummary.new('foo')
    ]
    people.featured_person(featured_summaries).name.must_equal('name1')
  end

  it 'returns nil if no featured person' do
    featured_summaries = [FakeSummary.new('foo'), FakeSummary.new('bar')]
    assert_nil(people.featured_person(featured_summaries))
  end

  it 'finds all people in a mapit area' do
    people.find_all_by_mapit_area(1).count.must_equal(3)
  end
end
