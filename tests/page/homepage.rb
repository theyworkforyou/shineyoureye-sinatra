# frozen_string_literal: true

require 'test_helper'
require_relative '../../lib/page/homepage'

describe 'Page::Homepage' do
  let(:documents) do
    [
      document_with_event_date('1000-01-11-foo', yesterday.to_s),
      document_with_event_date('1000-01-12-bar', today.to_s),
      document_with_event_date('1000-01-13-qux', tomorrow.to_s),
      document_with_event_date('1000-01-14-qux', in_two_weeks.to_s),
      document_with_event_date('1000-01-15-qux', in_two_weeks.to_s)
    ]
  end
  let(:page) do
    Page::Homepage.new(posts: documents, events: documents, governors: [], senators: [], representatives: [])
  end

  describe 'featured posts' do
    it 'sorts featured posts from newer to older' do
      first_is_newer = page.featured_posts.first.date > page.featured_posts.last.date
      first_is_newer.must_equal(true)
    end

    it 'has a maximum of two featured posts' do
      page.featured_posts.count(2)
    end
  end

  describe 'featured events' do
    it 'has featured events happening from today on' do
      is_future_date = page.featured_events.first.event_date >= today
      is_future_date.must_equal(true)
    end

    it 'sorts featured events from sooner to later' do
      first_is_sooner = page.featured_events.first.event_date <
                        page.featured_events.last.event_date
      first_is_sooner.must_equal(true)
    end

    it 'has a maximum of three featured events' do
      page.featured_events.count.must_equal(3)
    end

    it 'detects that there are no featured events' do
      page = Page::Homepage.new(posts: documents, events: [], governors: [], senators: [], representatives: [])
      page.no_events?.must_equal(true)
    end

    it 'throws an error if no event date exist' do
      document = basic_document(new_tempfile("---
title: A Title
---", '2000-20-02-file-name'))
      page = Page::Homepage.new(posts: [], events: [document], governors: [], senators: [], representatives: [])
      error = assert_raises(RuntimeError) { page.featured_events }
      error.message.must_include('A Title')
    end
  end

  it 'has the government representative types' do
    page.government_representative_types.count.must_equal(3)
  end

  it 'formats the date' do
    page.format_date(Date.iso8601('1000-10-01')).must_equal('October 1, 1000')
  end

  def yesterday
    today - 1
  end

  def today
    Date.today
  end

  def tomorrow
    today + 1
  end

  def in_two_weeks
    today + 14
  end

  def document_with_event_date(filename, event_date)
    contents = "---
eventdate: '#{event_date}'
---"
    basic_document(new_tempfile(contents, filename))
  end
end
