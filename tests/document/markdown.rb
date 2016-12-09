# frozen_string_literal: true
require 'test_helper'
require_relative '../../lib/document/markdown'

describe 'Document::Markdown' do
  describe '#raw' do
    it 'detects an empty file' do
      file = new_file('')
      Document::Markdown.new(filename: file.path).raw.must_equal('')
    end

    it 'returns nothing if there is frontmatter but no markdown' do
      file = new_file('---
foo: bar
---')
      Document::Markdown.new(filename: file.path).raw.must_equal('')
    end

    it 'returns only markdown if there is no frontmatter' do
      file = new_file('# A markdown header')
      markdown = Document::Markdown.new(filename: file.path)
      markdown.raw.must_equal('# A markdown header')
    end

    it 'returns only markdown if it has a frontmatter' do
      file = new_file('---
foo: bar
---
# A markdown header')
      markdown = Document::Markdown.new(filename: file.path)
      markdown.raw.must_equal('# A markdown header')
    end
  end

  describe '#as_html' do
    it 'returns html from markdown' do
      file = new_file('---
foo: bar
---
# A markdown header')
      markdown = Document::Markdown.new(filename: file.path)
      markdown.as_html.strip.must_equal('<h1>A markdown header</h1>')
    end
  end
end
