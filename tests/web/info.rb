# frozen_string_literal: true
require 'test_helper'
require_relative '../../app'

describe 'Info Page' do
  before { get '/info/about' }
  subject { Nokogiri::HTML(last_response.body) }

  it 'shows the post title' do
    subject.css('.page-title').text.must_equal("About")
  end

  it 'displays the contents of the page' do
    subject.css('.markdown.infopage').text
      .must_include('Shine your Eye is an initiative of Enough is Enough Nigeria')
  end
end
