# frozen_string_literal: true
require 'test_helper'
require_relative '../../lib/document/markdown_with_frontmatter'

describe 'Document::MarkdownWithFrontmatter' do
  let(:file) { new_file('---
title: A Title
slug: a-slug
published: true
---
# Hello World')
  }
  let(:document) { Document::MarkdownWithFrontmatter.new(
    filename: file.path,
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
end
