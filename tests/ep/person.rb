# frozen_string_literal: true

require 'test_helper'
require_relative '../shared_examples/person_interface_test'
require_relative '../../lib/ep/everypolitician_extensions'
require_relative '../../lib/ep/person'

describe 'EP::Person' do
  include PersonInterfaceTest
  let(:person) { ep_person('9de46243-685e-4902-81d4-b3e01faa93d5') }

  describe 'person proxy images' do
    it 'has a thumbnail image' do
      person.thumbnail_image_url.must_include('100x100.jpeg')
    end

    it 'has a URL for a medium-sized image' do
      person.medium_image_url.must_include('250x250.jpeg')
    end

    it 'has a URL for the original-sized image' do
      person.original_image_url.must_include('original.jpeg')
    end

    it 'uses the legislature slug in the proxy image url' do
      person.thumbnail_image_url.must_include('Senate')
    end

    it 'uses the person id in the proxy image url' do
      person.thumbnail_image_url.must_include('9de46243-685e-4902-81d4-b3e01faa93d5')
    end

    it 'throws an exception if the image size does not exist' do
      error = assert_raises(RuntimeError) { person.send(:proxy_image_variant, :tiny) }
      error.message.must_include('tiny')
    end

    it 'returns nil if there is no image' do
      person = ep_person('78a5c98d-8bbb-45ec-8faa-937d77a93191')
      assert_nil(person.thumbnail_image_url)
      assert_nil(person.medium_image_url)
      assert_nil(person.original_image_url)
    end
  end

  describe 'person social' do
    it 'has a Twitter display' do
      person = ep_person('13721811-4357-419c-8ca7-8f1170b36f1a')
      person.twitter_display.must_equal('@benmurraybruce')
    end

    it 'has a Twitter url' do
      person = ep_person('13721811-4357-419c-8ca7-8f1170b36f1a')
      person.twitter_url.must_equal('https://twitter.com/benmurraybruce')
    end

    it 'returns nil for display if no Twitter' do
      assert_nil(person.twitter_display)
    end

    it 'returns nil for url if no Twitter' do
      assert_nil(person.twitter_url)
    end

    it 'has a Facebook display' do
      person_with_facebook = person.extend(Facebook)
      person_with_facebook.facebook_display.must_equal('afacebookuser')
    end

    it 'has a Facebook url' do
      person_with_facebook = person.extend(Facebook)
      person_with_facebook.facebook_url.must_equal('https://facebook.com/afacebookuser')
    end

    it 'returns nil for the display if no Facebook' do
      assert_nil(person.facebook_display)
    end

    it 'returns nil for the url if no Facebook' do
      assert_nil(person.facebook_url)
    end

    it 'has an email url' do
      person.email_url.must_equal('mailto:adamu.abdullahi@gmail.com')
    end

    it 'returns nil for email url if no email' do
      person = ep_person('0b536a2c-2bc9-46a0-8d40-0deb9241cb31')
      assert_nil(person.email_url)
    end
  end

  it 'has an EveryPolitician id' do
    person.id.must_equal('9de46243-685e-4902-81d4-b3e01faa93d5')
  end

  it 'has a full name' do
    person.name.must_equal('ABDULLAHI ADAMU')
  end

  describe 'image' do
    it 'has an image' do
      person.image.must_equal('https://www.nass.gov.ng/images/mps/852.jpg')
    end

    it 'returns nil if no image' do
      person = ep_person('78a5c98d-8bbb-45ec-8faa-937d77a93191')
      assert_nil(person.image)
    end
  end

  describe 'date of birth' do
    it 'has a date of birth' do
      person.birth_date.must_equal('1946-07-23')
    end

    it 'returns nil when no date of birth' do
      person = ep_person('0b536a2c-2bc9-46a0-8d40-0deb9241cb31')
      assert_nil(person.birth_date)
    end
  end

  describe 'phone' do
    it 'has a phone' do
      person.phone.must_equal('08065186557')
    end

    it 'returns nil when no phone' do
      person = ep_person('0de9e40b-52bc-459f-978b-2aea514eec79')
      assert_nil(person.phone)
    end
  end

  describe 'Twitter' do
    it 'has Twitter' do
      person = ep_person('13721811-4357-419c-8ca7-8f1170b36f1a')
      person.twitter.must_equal('benmurraybruce')
    end

    it 'returns nil if no Twitter' do
      assert_nil(person.twitter)
    end
  end

  describe 'Facebook' do
    it 'has Facebook' do
      person_with_facebook = person.extend(Facebook)
      person_with_facebook.facebook.must_equal('https://facebook.com/afacebookuser')
    end

    it 'returns nil if no Facebook' do
      assert_nil(person.facebook)
    end
  end

  describe 'wikipedia url' do
    it 'has a Wikipedia url' do
      person.wikipedia_url.must_equal('https://en.wikipedia.org/wiki/Abdullahi_Adamu')
    end

    it 'returns nil if no wikipedia url' do
      person = ep_person('0b536a2c-2bc9-46a0-8d40-0deb9241cb31')
      assert_nil(person.wikipedia_url)
    end
  end

  describe 'email' do
    it 'has an email' do
      person.email.must_equal('adamu.abdullahi@gmail.com')
    end

    it 'returns nil if no email' do
      person = ep_person('0b536a2c-2bc9-46a0-8d40-0deb9241cb31')
      assert_nil(person.email)
    end
  end

  it 'has the membership for that person' do
    person.current_memberships.first[:person_id].must_equal('9de46243-685e-4902-81d4-b3e01faa93d5')
  end

  it 'has the person membership for the last term' do
    person.current_memberships.first[:legislative_period_id].must_equal('term/8')
  end

  it 'knows its mapit area id' do
    person.area.id.must_equal(1)
  end

  it 'knows its party id' do
    person.party_id.must_equal('APC')
  end

  it 'knows its party name' do
    person.party_name.must_equal('All Progressives Congress')
  end

  describe 'url' do
    it 'has a url' do
      person.url.must_equal('/baseurl/adamu-abdullahi/')
    end
  end

  describe 'slug' do
    it 'has a slug' do
      person.slug.must_equal('adamu-abdullahi')
    end

    it 'returns nil if no slug' do
      person = ep_person('0b536a2c-2bc9-46a0-8d40-0deb9241cb31')
      def person.extra_slug
        nil
      end
      assert_nil(person.slug)
    end
  end

  def ep_person(id)
    EP::Person.new(
      person: person_by_id(id),
      term: latest_term,
      mapit: FakeMapit.new(1),
      baseurl: '/baseurl/',
      identifier_scheme: 'shineyoureye'
    )
  end

  def person_by_id(id)
    latest_term.people.find { |person| person.id == id }
  end

  def latest_term
    legislature = nigeria_at_known_revision.legislature('Senate')
    legislature.legislative_periods.max_by(&:start_date)
  end

  module Facebook
    def facebook
      'https://facebook.com/afacebookuser'
    end
  end
end
