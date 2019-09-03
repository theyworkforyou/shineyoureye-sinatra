# frozen_string_literal: true

require 'test_helper'
require_relative '../../lib/page/post'

describe 'Page::Post' do
  let(:page) { Page::Post.new(post: FakePost.new('2016-01-01-foo')) }

  it 'has a title' do
    page.title.must_equal('A Title')
  end

  it 'formats the post date' do
    page.date.must_equal('January 1, 2016')
  end

  it 'has the post contents' do
    page.body.must_include('Hello World')
  end

  FakePost = Struct.new(:filename) do
    def title
      'A Title'
    end

    def date
      Date.iso8601(filename[0..9])
    end

    def body
      'Hello World'
    end
  end
end
