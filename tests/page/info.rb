# frozen_string_literal: true
require 'test_helper'
require_relative '../../lib/page/info'

describe 'Page::Info' do
  let(:contents) { '---
title: A Title
---
# Hello World' }
  let(:filenames) { [new_tempfile(contents, 'info-page-slug')] }
  let(:page) { Page::Info.new(directory: Dir.tmpdir, slug: 'info-page-slug') }

  it 'has a title' do
    Dir.stub :glob, filenames do
      page.title.must_equal('A Title')
    end
  end

  it 'has a body' do
    Dir.stub :glob, filenames do
      page.body.must_include('<h1>Hello World</h1>')
    end
  end

  describe 'when it fails to find a static page' do
    it 'detects that there are no pages with a slug' do
      filenames = []
      Dir.stub :glob, filenames do
        page.none?.must_equal(true)
      end
    end
  end
end
