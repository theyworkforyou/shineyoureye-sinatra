# frozen_string_literal: true

require 'test_helper'
require_relative '../../lib/document/frontmatter_parser'

describe 'Document::FrontmatterParser' do
  describe 'when file has frontmatter' do
    it 'finds the title' do
      contents = '---
title: A Title
---'
      parser(contents).title.must_equal('A Title')
    end

    it 'returns an empty string if there is no title' do
      contents = '---
foo: bar
---'
      parser(contents).title.must_equal('')
    end

    it 'finds the slug' do
      contents = '---
slug: a-slug
---'
      parser(contents).slug.must_equal('a-slug')
    end

    it 'knows if it is published' do
      contents = '---
published: false
---'
      parser(contents).published?.must_equal(false)
    end

    it 'publishes by default if there is no published field' do
      contents = '---
foo: bar
---'
      parser(contents).published?.must_equal(true)
    end

    it 'knows if it is featured' do
      contents = '---
featured: true
---'
      parser(contents).featured?.must_equal(true)
    end

    it 'is not featured by default' do
      contents = '---
foo: bar
---'
      parser(contents).featured?.must_equal(false)
    end

    it 'has an event date' do
      contents = "---
eventdate: '2010-01-01 10:00 +0000'
---"
      parser(contents).event_date.must_equal('2010-01-01 10:00 +0000')
    end

    it 'if there is no event date, returns an empty string' do
      contents = '---
foo: bar
---'
      parser(contents).event_date.must_equal('')
    end
  end

  describe 'when file has frontmatter and markdown' do
    it 'still finds the title' do
      contents = '---
title: A Title
---
# some markdown here'
      parser(contents).title.must_equal('A Title')
    end
  end

  describe 'when frontmatter is empty' do
    it 'returns an empty string' do
      contents = '---
---'
      parser(contents).title.must_equal('')
    end
  end

  describe 'when file is empty' do
    it 'does not break' do
      contents = ''
      parser(contents).title.must_equal('')
    end
  end

  def parser(contents)
    Document::FrontmatterParser.new(filecontents: contents)
  end
end
