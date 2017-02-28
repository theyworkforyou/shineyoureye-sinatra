# frozen_string_literal: true
require 'test_helper'
require_relative '../../lib/morph/person'

describe 'Morph::Person' do
  let(:person) { morph_person(person_row) }

  it 'has an id' do
    person.id.must_equal('gov:victor-okezie-ikpeazu')
  end

  it 'has a name' do
    person.name.must_equal('Victor Okezie Ikpeazu')
  end

  describe 'images' do
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
      person.thumbnail_image_url.must_include('Governors')
    end

    it 'uses the person id in the proxy image url' do
      person.thumbnail_image_url.must_include('gov:victor-okezie-ikpeazu')
    end

    it 'throws an exception if the image size does not exist' do
      error = assert_raises(RuntimeError) { person.send(:proxy_image_variant, :tiny) }
      error.message.must_include('tiny')
    end
  end

  describe 'date of birth' do
    it 'has a date of birth' do
      person.birth_date.must_equal('1964-10-18')
    end

    it 'returns nil when no date of birth' do
      person = morph_person(person_row_with_no_data)
      assert_nil(person.birth_date)
    end
  end

  describe 'phone' do
    it 'has a phone' do
      person.phone.must_equal('7030152466, 08063496033, 08035879790')
    end

    it 'returns nil when no phone' do
      person = morph_person(person_row_with_no_data)
      assert_nil(person.phone)
    end
  end

  describe 'when it has Twitter' do
    it 'has Twitter' do
      person.twitter.must_equal('GovDickson')
    end

    it 'has a Twitter display' do
      person.twitter_display.must_equal('@GovDickson')
    end

    it 'has a Twitter url' do
      person.twitter_url.must_equal('https://twitter.com/GovDickson')
    end
  end

  describe 'when it has no Twitter' do
    let (:person) { morph_person(person_row_with_no_data) }

    it 'returns nil for Twitter' do
      assert_nil(person.twitter)
    end

    it 'returns nil for the Twitter display' do
      assert_nil(person.twitter_display)
    end

    it 'returns nil for the Twitter url' do
      assert_nil(person.twitter_url)
    end
  end

  describe 'when it has Facebook' do
    it 'has Facebook' do
      person.facebook.must_equal('https://www.facebook.com/OyoStateGovernment')
    end

    it 'has a Facebook display' do
      person.facebook_display.must_equal('OyoStateGovernment')
    end

    it 'has a Facebook url' do
      person.facebook_url.must_equal('https://www.facebook.com/OyoStateGovernment')
    end
  end

  describe 'when it has no Facebook' do
    let(:person) { morph_person(person_row_with_no_data) }

    it 'returns nil for Facebook' do
      assert_nil(person.facebook)
    end

    it 'returns nil for the Facebook display' do
      assert_nil(person.facebook_display)
    end

    it 'returns nil for the Facebook url' do
      assert_nil(person.facebook_url)
    end
  end

  it 'does not come with a wikipedia url' do
    assert_nil(person.wikipedia_url)
  end

  describe 'when it has an email' do
    it 'has an email' do
      person.email.must_equal('info@abiastate.gov.ng')
    end

    it 'has an email url' do
      person.email_url.must_equal('mailto:info@abiastate.gov.ng')
    end
  end

  describe 'when it has no email' do
    let(:person) { morph_person(person_row_with_no_data) }

    it 'returns nil for an email' do
      assert_nil(person.email)
    end

    it 'returns nil for an email url' do
      assert_nil(person.email_url)
    end
  end

  it 'knows its mapit area id' do
    person.area.id.must_equal(1)
  end

  it 'knows its party id' do
    person.party_id.must_equal('PDP')
  end

  it 'knows its party name' do
    person.party_name.must_equal('PDP')
  end

  it 'knows its party url' do
    person.party_url.must_equal('/organisation/pdp/')
  end

  it 'has a url' do
    person.url.must_equal('/baseurl/okezie-ikpeazu/')
  end

  def morph_person(row)
    Morph::Person.new(
      person: row,
      mapit: FakeMapit.new(1),
      baseurl: '/baseurl/'
    )
  end

  def person_row
    {
      'honorific_prefix' => 'Dr',
      'name' => 'Victor Okezie Ikpeazu',
      'id' => 'gov:victor-okezie-ikpeazu',
      'state' => 'Abia',
      'party' => 'PDP',
      'email' => 'info@abiastate.gov.ng;person@example.com',
      'phone' => '7030152466;08063496033;08035879790',
      'twitter' => 'GovDickson;DicksonSeriake',
      'facebook_url' => 'https://www.facebook.com/OyoStateGovernment;http://www.facebook.com/AbiolaAjimobi',
      'birth_date' => '1964-10-18',
      'gender' => 'Male',
      'identifier__shineyoureye' => 'okezie-ikpeazu',
      'image_url' => 'http://www.shineyoureye.org/media_root/images/Abia_-_Okezie_Ikpeazu.jpg',
      'website_url' => 'http://ekitistate.gov.ng/',
      'other_names' => 'Okezie Ikpeazu'
    }
  end

  def person_row_with_no_data
    person_row.each_with_object({}) { |(key, value), memo| memo[key] = nil }
  end
end
