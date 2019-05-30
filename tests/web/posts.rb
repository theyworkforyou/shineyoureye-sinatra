# frozen_string_literal: true

require 'test_helper'

describe 'Posts Page' do
  before { get '/blog/' }
  subject { Nokogiri::HTML(last_response.body) }

  it 'shows the title' do
    subject.css('h1').first.text.must_equal('Blog')
  end

  it 'shows all posts' do
    more_than_one = subject.css('.blog-in-a-list').count > 1
    more_than_one.must_equal(true)
  end

  describe 'when displaying a post' do
    let(:single_post) { subject.css('.blog-in-a-list').first }

    it 'links to post url' do
      single_post.css('h2 a/@href').text.must_equal('/blog/sye-week-in-review-may-24-2019')
    end

    it 'displays post title' do
      single_post.css('h2').text.must_equal('SYE Week in Review, May 24, 2019')
    end

    it 'displays post date' do
      single_post.css('.meta').text.must_equal('May 27, 2019')
    end
  end
end
