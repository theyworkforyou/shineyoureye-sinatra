# frozen_string_literal: true
require 'test_helper'
require_relative '../../lib/document/markdown_with_frontmatter'

describe 'Document::MarkdownWithFrontmatter' do
  let(:filename) { new_tempfile('---
title: A Title
slug: a-slug
published: true
---
# Hello World')
  }
  let(:document) { Document::MarkdownWithFrontmatter.new(
    filename: filename,
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
    filename_with_date = new_tempfile('', '1000-10-01-filename')
    document = Document::MarkdownWithFrontmatter.new(
      filename: filename_with_date,
      baseurl: '/events/'
    )
    document.date.year.must_equal(1000)
    document.date.month.must_equal(10)
    document.date.day.must_equal(1)
  end
end
