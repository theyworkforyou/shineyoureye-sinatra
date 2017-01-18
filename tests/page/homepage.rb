# frozen_string_literal: true
require 'test_helper'
require_relative '../../lib/page/homepage'

describe 'Page::Homepage' do
  let(:documents) { [
    FakeDocument.new('1000-01-11-foo'),
    FakeDocument.new('1000-01-12-bar'),
    FakeDocument.new('1000-01-13-qux'),
    FakeDocument.new('1000-01-14-qux')
  ] }
  let(:page) { Page::Homepage.new(posts: documents, events: documents) }

  describe 'featured posts' do
    it 'sorts featured posts from newer to older' do
      first_is_newer = page.featured_posts.first.date > page.featured_posts.last.date
      first_is_newer.must_equal(true)
    end

    it 'has a maximum of three featured posts' do
      page.featured_posts.count(3)
    end
  end

  describe 'featured events' do
    it 'sorts featured events from newer to older' do
      first_is_newer = page.featured_events.first.date >
                       page.featured_events.last.date
      first_is_newer.must_equal(true)
    end

    it 'has a maximum of three featured events' do
      page.featured_events.count.must_equal(3)
    end
  end

  it 'formats the date' do
    page.format_date(Date.iso8601('1000-10-01')).must_equal('October 1, 1000')
  end

  FakeDocument = Struct.new(:filename) do
    def date
      Date.iso8601(filename[0..9])
    end
  end
end
