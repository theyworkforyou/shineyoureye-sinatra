# frozen_string_literal: true
require 'test_helper'
require_relative '../../app'

describe 'Layout' do
  before  { get '/info/about' }
  subject { Nokogiri::HTML(last_response.body) }

  it 'includes the head' do
    refute_empty(subject.css('title').text)
  end

  it 'includes the main menu' do
    refute_empty(subject.css('.main-menu'))
  end

  it 'includes the header' do
    refute_empty(subject.css('header menu'))
  end

  it 'includes the footer' do
    refute_empty(subject.css('.site-footer'))
  end
end
