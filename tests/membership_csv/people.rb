# frozen_string_literal: true
require 'test_helper'
require_relative '../../lib/membership_csv/people'

describe 'MembershipCSV::People' do
  let(:contents) do
    'id,name,identifier__shineyoureye,phone
id1,name1,name-1,1234
id2,name2,name-2,5678
id3,name3,name-3,'
  end
  let(:people) do
    MembershipCSV::People.new(
      csv_filename: new_tempfile(contents),
      mapit: 'irrelevant',
      baseurl: '/baseurl/'
    )
  end

  it 'finds all people' do
    people.find_all.count.must_equal(3)
  end

  it 'finds all people as persons' do
    people.find_all.first.id.must_equal('id1')
  end

  it 'uses the baseurl in the person url' do
    people.find_all.first.url.must_equal('/baseurl/id1/')
  end

  it 'returns nil for empty fields' do
    assert_nil(people.find_all.last.phone)
  end

  it 'finds all people sorted by name' do
    sorted_alphabetically = people.find_all.first.name < people.find_all.last.name
    sorted_alphabetically.must_equal(true)
  end

  it 'finds by id' do
    people.find_single('id2').name.must_equal('name2')
  end

  it 'can check if id does not exist' do
    people.none?('i-do-not-exist').must_equal(true)
  end

  describe 'extra mapit functionality' do
    let(:people) do
      MembershipCSV::People.new(
        csv_filename: new_tempfile(contents),
        mapit: FakeMapit.new(1),
        baseurl: '/baseurl/'
      )
    end

    it 'assigns a mapit area to the person' do
      people.find_single('id3').area.id.must_equal(1)
    end

    it 'finds all people in a mapit area' do
      people.find_all_by_mapit_area(1).count.must_equal(3)
    end
  end
end
