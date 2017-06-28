# frozen_string_literal: true
require 'test_helper'
require_relative '../../lib/document/markdown_with_frontmatter'

describe 'Document::MarkdownWithFrontmatter' do
  let(:contents) do
    "---
title: A Title
slug: a-slug
published: true
eventdate: '2000-01-01 15:00 +0000'
---
# Hello World"
  end
  let(:document) do
    Document::MarkdownWithFrontmatter.new(
      filename: new_tempfile(contents, '1000-10-01-file-name'),
      baseurl: '/events/'
    )
  end

  it 'has a title' do
    document.title.must_equal('A Title')
  end

  it 'has a url' do
    expected_slug = File.basename(document.send(:filename), '.*').gsub(/^1000-10-01-/, '')
    document.url.must_equal("/events/#{expected_slug}")
  end

  it 'has a published field' do
    document.published?.must_equal(true)
  end

  it 'has a body' do
    document.body.strip.must_equal('<h1>Hello World</h1>')
  end

  it 'has a date' do
    document.date.year.must_equal(1000)
    document.date.month.must_equal(10)
    document.date.day.must_equal(1)
  end

  it 'is not featured' do
    document.featured?.must_equal(false)
  end

  it 'has an event date' do
    document.event_date.year.must_equal(2000)
    document.event_date.month.must_equal(1)
    document.event_date.day.must_equal(1)
  end

  describe 'when there is no slug field' do
    it 'builds the slug from the filename' do
      document = basic_document(new_tempfile('', '2000-20-02-file-name'))
      document.slug.must_include('file-name')
    end

    it 'builds the slug if no date in filename' do
      document = basic_document(new_tempfile('', '1234-5678'))
      document.slug.must_include('1234-5678')
    end
  end

  describe 'when there is no date in the filename' do
    it 'returns nil' do
      document = basic_document('file-name')
      assert_nil(document.date)
    end
  end

  describe 'when there is no event date field' do
    it 'returns nil' do
      document = basic_document(new_tempfile('', '2000-20-02-file-name'))
      assert_nil(document.event_date)
    end
  end

  describe 'when other formats in event date field' do
    it 'parses a slashed date' do
      document = basic_document(new_tempfile("---
eventdate: '24/1/2017'
---", '2000-20-02-file-name'))
      document.event_date.year.must_equal(2017)
      document.event_date.month.must_equal(1)
      document.event_date.day.must_equal(24)
    end

    it 'parses a date with spaces and named month' do
      document = basic_document(new_tempfile("---
eventdate: '24 March 2017'
---", '2000-20-02-file-name'))
      document.event_date.year.must_equal(2017)
      document.event_date.month.must_equal(3)
      document.event_date.day.must_equal(24)
    end

    it 'parses a plain ISO-8601 date' do
      document = basic_document(new_tempfile("---
eventdate: '2017-01-24'
---", '2000-20-02-file-name'))
      document.event_date.year.must_equal(2017)
      document.event_date.month.must_equal(1)
      document.event_date.day.must_equal(24)
    end
  end
end
