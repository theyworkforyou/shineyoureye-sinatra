# frozen_string_literal: true
require 'test_helper'
require_relative '../../app'

describe 'Posts Page' do
  before { get '/blog/' }
  subject { Nokogiri::HTML(last_response.body) }

  it 'shows all posts' do
    more_than_one = subject.css('.blog-in-a-list').count > 1
    more_than_one.must_equal(true)
  end

  describe 'when displaying a post' do
    let(:single_post) { subject.css('.blog-in-a-list').last }

    it 'links to post url' do
      single_post.css('h2 a/@href').text.must_equal('/blog/citizens-solutions-end-terrorism')
    end

    it 'displays post title' do
      single_post.css('h2').text.must_equal('Citizens’ Solutions to End Terrorism')
    end

    it 'displays post date' do
      single_post.css('.meta').text.must_equal('April 18, 2014')
    end

    it 'displays post excerpt' do
      single_post.css('div').text.must_include('Nigerians woke up to news')
    end
  end
end
