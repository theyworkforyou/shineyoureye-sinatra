# frozen_string_literal: true

require 'test_helper'
require_relative '../../lib/factory/person'

describe 'Factory::Person' do
  let(:factory) do
    Factory::Person.new(
      mapit: FakeMapit.new(1),
      baseurl: '/baseurl/',
      identifier_scheme: 'shineyoureye'
    )
  end

  describe 'EP Person' do
    let(:person) { factory.build_ep_person(people.first, FakeTerm.new('term/8')) }

    it 'creates an EP Person' do
      person.class.must_equal(EP::Person)
    end

    it 'uses the person object from the EP gem' do
      person.id.must_equal('003e0736-add0-4997-9444-94fac606bb95')
    end

    it 'uses the term' do
      person.party_id.must_equal('APC')
    end

    it 'uses the Mapit object' do
      person.area.id.must_equal(1)
    end

    it 'uses the baseurl' do
      person.url.must_include('/baseurl/')
    end

    it 'uses the identifier_scheme' do
      person.slug.must_equal('mallam-gana')
    end

    def people
      @people ||= nigeria_at_known_revision.legislature('Representatives').popolo.persons
    end

    FakeTerm = Struct.new(:id)
  end

  describe 'MembershipCSV' do
    let(:person) { factory.build_csv_person(csv_person) }

    it 'creates a CSV Person' do
      person.class.must_equal(MembershipCSV::Person)
    end

    it 'uses the person hash from the CSV file' do
      person.id.must_equal('gov:victor-okezie-ikpeazu')
    end

    it 'uses the Mapit object' do
      person.area.id.must_equal(1)
    end

    it 'uses the baseurl' do
      person.url.must_include('/baseurl/')
    end

    it 'uses the identifier_scheme' do
      person.slug.must_equal('okezie-ikpeazu')
    end

    def csv_person
      {
        'id' => 'gov:victor-okezie-ikpeazu',
        'state' => 'Abia',
        'identifier__shineyoureye' => 'okezie-ikpeazu'
      }
    end
  end
end
