# frozen_string_literal: true
require 'test_helper'
require_relative '../../app'

describe 'Search Page' do
  before { get '/search/' }
  subject { Nokogiri::HTML(last_response.body) }

  it 'has a title' do
    subject.css('title').text.must_include('Search')
  end

  it 'includes the search form' do
    refute_nil(subject.css('site-header__search'))
  end
end
