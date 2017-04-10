# frozen_string_literal: true
require 'test_helper'
require_relative '../../lib/document/markdown_parser'

describe 'Document::MarkdownParser' do
  describe '#raw' do
    it 'detects an empty file' do
      contents = ''
      parser(contents).raw.must_equal('')
    end

    it 'returns nothing if there is frontmatter but no markdown' do
      contents = '---
foo: bar
---'
      parser(contents).raw.must_equal('')
    end

    it 'returns only markdown if there is no frontmatter' do
      contents = '# A markdown header'
      parser(contents).raw.must_equal('# A markdown header')
    end

    it 'returns only markdown if it has a frontmatter' do
      contents = '---
foo: bar
---
# A markdown header'
      parser(contents).raw.must_equal('# A markdown header')
    end
  end

  describe '#as_html' do
    it 'returns html from markdown' do
      contents = '---
foo: bar
---
# A markdown header'
      parser(contents).as_html.strip.must_equal('<h1>A markdown header</h1>')
    end

    it 'strips out any Jekyll {{site.baseurl}} markup' do
      contents = '---
---
![infographic.png]({{site.baseurl}}/media/prose-images/infographic.png)'
      expected = '<p><img src="/media/prose-images/infographic.png" ' \
                 'alt="infographic.png" /></p>'
      parser(contents).as_html.strip.must_equal(expected)
    end
  end

  def parser(contents)
    Document::MarkdownParser.new(filecontents: contents)
  end
end
