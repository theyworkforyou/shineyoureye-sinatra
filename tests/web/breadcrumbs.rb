# frozen_string_literal: true
require 'test_helper'
require_relative '../../app'

describe 'Blog index page' do
  before { get '/blog/' }
  subject { Nokogiri::HTML(last_response.body) }

  it 'contains the expected breadcrumbs' do
    breadcrumbs_ol = subject.css('ol.breadcrumb')
    lis = breadcrumbs_ol.xpath('.//li')
    assert_equal(2, lis.count)
    assert_equal('<li><a href="/">Home</a></li>', lis[0].to_s)
    assert_equal('<li class="active">Blog</li>', lis[1].to_s)
  end
end

describe 'Home page' do
  before { get '/' }
  subject { Nokogiri::HTML(last_response.body) }

  it 'contains no breadcrumbs string' do
    assert_empty(subject.css('ol.breadcrumb'))
  end
end
