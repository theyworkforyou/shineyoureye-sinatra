# frozen_string_literal: true
require 'test_helper'
require_relative '../../lib/document/finder'

describe 'Document::Finder' do
  let(:filename) { 'file-name' }
  let(:finder) { Document::Finder.new(pattern: "#{filename}.md", baseurl: '/path/') }

  it 'finds a single document' do
    Dir.stub :glob, [new_tempfile('')] do
      finder.find_single.class.must_equal(Document::MarkdownWithFrontmatter)
    end
  end

  it 'finds several documents' do
    Dir.stub :glob, [new_tempfile(''), new_tempfile('')] do
      finder.find_published.count.must_equal(2)
    end
  end

  it 'returns only published documents' do
    published = '---
published: true
---'
    nofield = '---
---'
    unpublished = '---
published: false
---'
    filenames = [new_tempfile(published), new_tempfile(nofield), new_tempfile(unpublished)]
    Dir.stub :glob, filenames do
      finder.find_published.count.must_equal(2)
    end
  end

  it 'can find unpublished documents' do
    published = '---
published: true
---'
    unpublished = '---
published: false
---'
    Dir.stub :glob, [new_tempfile(published), new_tempfile(unpublished), new_tempfile(unpublished)] do
      finder.find_unpublished.count.must_equal(2)
    end
  end

  it 'creates a document with the right url' do
    contents = '---
slug: a-slug
---'
    Dir.stub :glob, [new_tempfile(contents, filename)] do
      expected_slug = File.basename(Dir.glob[0], '.*')
      finder.find_single.url.must_equal("/path/#{expected_slug}")
    end
  end

  it 'sorts the found filenames alphabetically' do
    Dir.stub :glob, [new_tempfile('', 'zed'), new_tempfile('', 'be')] do
      finder.find_published.first.send(:basename).start_with?('be').must_equal(true)
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

    describe 'when searching featured documents' do
      let(:contents) do
        '---
featured: true
---
# Foo'
      end
      let(:files) { [new_tempfile(contents, 'foo'), new_tempfile(contents, 'bar')] }

      it 'gets all' do
        Dir.stub :glob, files do
          finder.find_featured.count.must_equal(2)
        end
      end

      it 'gets all as documents' do
        Dir.stub :glob, files do
          finder.find_featured.first.body.strip.must_equal('<h1>Foo</h1>')
        end
      end
    end
  end
end
