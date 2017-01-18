# frozen_string_literal: true
require 'test_helper'
require_relative '../../lib/document/finder'

describe 'Document::Finder' do
  let(:filename) { 'file-name' }
  let(:finder) { Document::Finder.new(pattern: './file-name.md', baseurl: '/path/') }

  it 'finds a single document' do
    Dir.stub :glob, [filename] do
      finder.find_single.class.must_equal(Document::MarkdownWithFrontmatter)
    end
  end

  it 'creates a document with the right url' do
    contents = '---
slug: a-slug
---'
    Dir.stub :glob, [new_tempfile(contents, filename)] do
      finder.find_single.url.must_equal('/path/a-slug')
    end
  end

  it 'finds several documents' do
    Dir.stub :glob, [filename, 'another-file'] do
      finder.find_all.count.must_equal(2)
    end
  end

  describe 'when it fails to find a document' do
    it 'detects multiple documents with same name and different dates' do
      Dir.stub :glob, ['2016-01-01-file-name', '2012-01-01-file-name'] do
        error = assert_raises(RuntimeError) { finder.find_single }
        error.message.must_include('file-name.md')
      end
    end

    it 'detects that there are no documents with a slug' do
      Dir.stub :glob, [] do
        require 'sinatra'
        assert_raises(Sinatra::NotFound) { finder.find_single }
      end
    end
  end
end
