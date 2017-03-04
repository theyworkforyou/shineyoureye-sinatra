# frozen_string_literal: true
require 'test_helper'
require_relative '../../lib/page/posts'

describe 'Page::Posts' do
  let(:posts) do
    [
      FakeDoc.new('2016-01-01-foo', '/blog/'),
      FakeDoc.new('2012-01-01-bar', '/blog/')
    ]
  end
  let(:page) { Page::Posts.new(posts: posts, title: 'Blog') }

  it 'has a title' do
    page.title.must_equal('Blog')
  end

  it 'retrieves all posts' do
    page.sorted_posts.count.must_equal(2)
  end

  it 'links posts to a url under the blog path' do
    first.url.must_equal('/blog/foo')
    last.url.must_equal('/blog/bar')
  end

  it 'sorts the posts from newer to older' do
    first_is_newer = first.date > last.date
    first_is_newer.must_equal(true)
  end

  it 'formats the date' do
    page.format_date(Date.iso8601('1000-10-01')).must_equal('October 1, 1000')
  end

  def first
    page.sorted_posts.first
  end

  def last
    page.sorted_posts.last
  end

  FakeDoc = Struct.new(:filename, :baseurl) do
    def url
      baseurl + filename[-3..-1]
    end

    def date
      Date.iso8601(filename[0..9])
    end
  end
end
