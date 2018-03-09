# frozen_string_literal: true

require 'test_helper'

describe 'Layout' do
  before { get '/info/about' }
  subject { Nokogiri::HTML(last_response.body) }

  it 'includes the head' do
    refute_empty(subject.css('title').text)
  end

  it 'includes the main menu' do
    refute_empty(subject.css('.main-menu'))
  end

  it 'includes the header' do
    refute_empty(subject.css('.site-header'))
  end

  it 'includes the footer' do
    refute_empty(subject.css('.site-footer'))
  end

  describe 'fonts' do
    before { get '/fonts/bootstrap/glyphicons-halflings-regular.woff2' }

    it 'loads fonts' do
      last_response.content_type.must_equal('application/font-woff2')
    end
  end

  describe 'javascript' do
    before { get '/javascripts/bootstrap/bootstrap.min.js' }

    it 'loads javascript' do
      last_response.content_type.must_equal('application/javascript;charset=utf-8')
    end
  end

  describe 'robots' do
    before { get '/robots.txt' }

    it 'disallows robots' do
      last_response.body.must_equal("User-agent: *\nDisallow:\n")
    end
  end
end
