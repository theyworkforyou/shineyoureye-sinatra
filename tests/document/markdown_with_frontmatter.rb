# frozen_string_literal: true
require 'test_helper'
require_relative '../../lib/document/markdown_with_frontmatter'

describe 'Document::MarkdownWithFrontmatter' do
  let(:contents) { '---
title: A Title
slug: a-slug
published: true
---
# Hello World' }
  let(:document) { Document::MarkdownWithFrontmatter.new(
    filename: new_tempfile(contents, '1000-10-01-file-name'),
    baseurl: '/events/')
  }

  it 'has a title' do
    document.title.must_equal('A Title')
  end

  it 'has a url' do
    document.url.must_equal('/events/a-slug')
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

  describe 'when there is no slug field' do
    it 'builds the url from the filename' do
      document = Document::MarkdownWithFrontmatter.new(
        filename: new_tempfile('', '2000-20-02-file-name'),
        baseurl: '/somepath/'
      )
      document.url.must_include('/somepath/file-name')
    end
  end

  describe 'when there is no date in the filename' do
    it 'returns nil' do
      document = Document::MarkdownWithFrontmatter.new(
        filename: 'file-name',
        baseurl: 'irrelevant'
      )
      assert_nil(document.date)
    end
  end
end
