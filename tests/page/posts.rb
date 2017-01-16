# frozen_string_literal: true
require 'test_helper'
require_relative '../../lib/page/posts'

describe 'Page::Posts' do
  let(:page) { Page::Posts.new(baseurl: '/blog/', directory: Dir.tmpdir) }
  let(:filenames) { ['2016-01-01-foo.md', '2012-01-01-bar.md'] }

  it 'retrieves all posts' do
    Dir.stub :glob, filenames do
      page.sorted_posts.count.must_equal(2)
    end
  end

  it 'links posts to a url under the blog path' do
    filenames = [
      new_tempfile('', '2016-01-01-foo'),
      new_tempfile('', '2012-01-01-bar')
    ]
    Dir.stub :glob, filenames do
      first.url.must_include("/blog/foo")
      last.url.must_include("/blog/bar")
    end
  end

  it 'sorts the posts from newer to older' do
    Dir.stub :glob, filenames do
      first_is_newer = first.date > last.date
      first_is_newer.must_equal(true)
    end
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
end
