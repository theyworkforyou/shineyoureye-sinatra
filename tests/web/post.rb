# frozen_string_literal: true
require 'test_helper'
require_relative '../../app'

describe 'Post Page' do
  before { get '/blog/citizens-solutions-end-terrorism' }
  subject { Nokogiri::HTML(last_response.body) }

  it 'shows the breadcrumbs' do
    subject.css('.breadcrumb li').count.must_equal(3)
    subject.css('.breadcrumb .active').text.must_equal('Citizens’ Solutions to End Terrorism')
  end

  it 'shows the post title' do
    subject.css('.page-title').text.must_equal("Citizens’ Solutions to End Terrorism")
  end

  it 'shows the date with the right format' do
    subject.css('.meta').first.text.must_equal('April 18, 2014')
  end

  it 'displays the contents of the post' do
    subject.css('.markdown.infopage').text.must_include('Nigerians woke up to news')
  end
end
