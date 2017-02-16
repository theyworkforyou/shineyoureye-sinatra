# frozen_string_literal: true
require 'test_helper'
require_relative '../../lib/ep/everypolitician_extensions'
require_relative '../../lib/ep/person'

describe 'EP::Person' do
  let(:person) { EP::Person.new(
    person: person_plus_missing_data,
    term: latest_term,
    mapit: FakeMapit.new,
    baseurl: '/baseurl/'
  ) }

  it 'has an EveryPolitician id' do
    person.id.must_equal('003e0736-add0-4997-9444-94fac606bb95')
  end

  it 'has a name' do
    person.name.must_equal('MALLAM GANA')
  end

  it 'has an image' do
    person.image.must_equal('http://www.nass.gov.ng/images/mps/avatar.jpg')
  end

  it 'has a proxy image' do
    person.proxy_image.must_include('100x100.jpeg')
  end

  it 'has a date of birth' do
    person.birth_date.must_equal('1000-01-10')
  end

  it 'has a phone' do
    person.phone.must_equal('1234 5678')
  end

  it 'has a Twitter' do
    person.twitter.must_equal('atwitterhandle')
  end

  it 'has a Twitter display' do
    person.twitter_display.must_equal('@atwitterhandle')
  end

  it 'has a Twitter url' do
    person.twitter_url.must_equal('https://twitter.com/atwitterhandle')
  end

  it 'has a Facebook' do
    person.facebook.must_equal('https://facebook.com/afacebookuser')
  end

  it 'has a Facebook display' do
    person.facebook_display.must_equal('afacebookuser')
  end

  it 'has a Facebook url' do
    person.facebook_url.must_equal('https://facebook.com/afacebookuser')
  end

  it 'has an email' do
    person.email.must_equal('person@example.com')
  end

  it 'has an email url' do
    person.email_url.must_equal('mailto:person@example.com')
  end

  it 'has the membership for that person' do
    person.current_memberships.first[:person_id].must_equal('003e0736-add0-4997-9444-94fac606bb95')
  end

  it 'has the person membership for the last term' do
    person.current_memberships.first[:legislative_period_id].must_equal('term/2015')
  end

  it 'knows its mapit area id' do
    person.area.id.must_equal('Mapit Area id')
  end

  it 'knows its mapit area name' do
    person.area.name.must_equal('Mapit Area Name')
  end

  it 'knows its party id' do
    person.party_id.must_equal('APC')
  end

  it 'knows its party name' do
    person.party_name.must_equal('All Progressives Congress')
  end

  it 'knows its party url' do
    person.party_url.must_equal('/organisation/apc/')
  end

  it 'has a url' do
    person.url.must_equal('/baseurl/003e0736-add0-4997-9444-94fac606bb95/')
  end

  def latest_term
    legislature = nigeria_at_known_revision.legislature('Representatives')
    legislature.legislative_periods.sort_by { |term| term.start_date }.last
  end

  def person_plus_missing_data
    person = latest_term.people.first
    person.extend MissingData
  end

  module MissingData
    def birth_date
      '1000-01-10'
    end

    def twitter
      'atwitterhandle'
    end

    def facebook
      'https://facebook.com/afacebookuser'
    end

    def email
      'person@example.com'
    end

    def phone
      '1234 5678'
    end
  end
end
