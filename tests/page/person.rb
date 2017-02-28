# frozen_string_literal: true
require 'test_helper'
require_relative '../../lib/ep/people_by_legislature'
require_relative '../../lib/page/person'

describe 'Page::Person' do
  let(:people) { EP::PeopleByLegislature.new(
    legislature: nigeria_at_known_revision.legislature('Representatives'),
    mapit: 'irrelevant',
    baseurl: 'irrelevant'
  ) }
  let(:page) { Page::Person.new(
    person: people.find_single('b2a7f72a-9ecf-4263-83f1-cb0f8783053c'),
    position: 'Position',
    summary_doc: FakeSummary.new('<p>foo</p>')
  ) }

  it 'knows the position' do
    page.position.must_equal('Position')
  end

  it 'has a page title' do
    page.title.must_equal('ABDUKADIR RAHIS')
  end

  it 'has a social media share name' do
    page.share_name.must_equal('ABDUKADIR RAHIS')
  end

  it 'has a summary' do
    page.summary.must_equal('<p>foo</p>')
  end

  describe 'person' do
    it 'has a url to a medium-sized image' do
      page.person.respond_to?(:medium_image_url).must_equal(true)
    end

    it 'has a name' do
      page.person.respond_to?(:name).must_equal(true)
    end

    it 'has an area' do
      page.person.respond_to?(:area).must_equal(true)
    end

    it 'has a party name' do
      page.person.respond_to?(:party_name).must_equal(true)
    end

    it 'has a birth date' do
      page.person.respond_to?(:birth_date).must_equal(true)
    end

    it 'has a phone' do
      page.person.respond_to?(:phone).must_equal(true)
    end

    it 'has a Twitter' do
      page.person.respond_to?(:twitter).must_equal(true)
    end

    it 'has a Twitter url' do
      page.person.respond_to?(:twitter_url).must_equal(true)
    end

    it 'has a Twitter display' do
      page.person.respond_to?(:twitter_display).must_equal(true)
    end

    it 'has a Facebook' do
      page.person.respond_to?(:facebook).must_equal(true)
    end

    it 'has a Facebook url' do
      page.person.respond_to?(:facebook_url).must_equal(true)
    end

    it 'has a Facebook display' do
      page.person.respond_to?(:facebook_display).must_equal(true)
    end

    it 'has an email' do
      page.person.respond_to?(:email).must_equal(true)
    end

    it 'has an email url' do
      page.person.respond_to?(:email_url).must_equal(true)
    end

    it 'has a wikipedia url' do
      page.person.respond_to?(:wikipedia_url).must_equal(true)
    end

    it 'has an id' do
      page.person.respond_to?(:id).must_equal(true)
    end
  end

  FakeSummary = Struct.new(:body)
end
