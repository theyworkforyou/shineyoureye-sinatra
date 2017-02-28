# frozen_string_literal: true
require 'test_helper'
require_relative '../../lib/document/finder'

describe 'Document::Finder' do
  let(:filename) { 'file-name' }
  let(:finder) { Document::Finder.new(pattern: 'file-name.md', baseurl: '/path/') }

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
    describe 'when multiple documents with same name and different dates' do
      it 'raises an exception if method is called directly' do
        Dir.stub :glob, ['2016-01-01-file-name', '2012-01-01-file-name'] do
          error = assert_raises(RuntimeError) { finder.find_single }
          error.message.must_include('file-name.md')
        end
      end

      it 'can check before calling the method' do
        Dir.stub :glob, ['2016-01-01-file-name', '2012-01-01-file-name'] do
          finder.multiple?.must_equal(true)
        end
      end
    end

    describe 'when there are no documents with a slug' do
      it 'raises an exception if method is called directly' do
        Dir.stub :glob, [] do
          error = assert_raises(Document::NoFilesFoundError) { finder.find_single }
          error.message.must_include('file-name.md')
        end
      end

      it 'can check before calling the method' do
        Dir.stub :glob, [] do
          finder.none?.must_equal(true)
        end
      end
    end

    describe 'when searching for a summary' do
      it 'can find a summary' do
        contents = '---
---
summary'
        Dir.stub :glob, [new_tempfile(contents)] do
          finder.find_or_empty.body.strip.must_equal('<p>summary</p>')
        end
      end
    end

    describe 'when no summary is found' do
      it 'returns a duck type' do
        Dir.stub :glob, [] do
          finder.find_or_empty.body.strip.must_equal('')
        end
      end
    end
  end
end
