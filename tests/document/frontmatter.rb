# frozen_string_literal: true
require 'test_helper'
require_relative '../../lib/document/frontmatter'

describe 'Document::Frontmatter' do
  describe 'when file has frontmatter' do
    it 'finds the title' do
      file = new_file('---
title: A Title
---')
      Document::Frontmatter.new(filename: file.path).title.must_equal('A Title')
    end

    it 'returns an empty string if there is no title' do
      file = new_file('---
foo: bar
---')
      Document::Frontmatter.new(filename: file.path).title.must_equal('')
    end

    it 'finds the slug' do
      file = new_file('---
slug: a-slug
---')
      Document::Frontmatter.new(filename: file.path).slug.must_equal('a-slug')
    end

    it 'knows if it is published' do
      file = new_file('---
published: true
---')
      Document::Frontmatter.new(filename: file.path).published?.must_equal(true)
    end
  end

  describe 'when file has frontmatter and markdown' do
    it 'still finds the title' do
      file = new_file('---
title: A Title
---
# some markdown here')
      Document::Frontmatter.new(filename: file.path).title.must_equal('A Title')
    end
  end

  describe 'when frontmatter is empty' do
    it 'sends an empty field' do
      file = new_file('---
---')
      Document::Frontmatter.new(filename: file.path).title.must_equal('')
    end
  end

  describe 'when file is empty' do
    it 'does not break' do
      file = new_file('')
      Document::Frontmatter.new(filename: file.path).title.must_equal('')
    end
  end
end
