# frozen_string_literal: true
require 'test_helper'

describe 'Contact Page' do
  before { get '/contact/' }
  subject { Nokogiri::HTML(last_response.body) }

  it 'has a title' do
    subject.css('title').text.must_include('Contact')
  end

  it 'displays the title on the page' do
    subject.css('.big-form h1').text.must_include('Contact')
  end

  it 'includes the site email in the contact form' do
    subject.css('.big-form/@action').text.must_include('user@example.com')
  end

  describe 'redirection from old route' do
    before { get '/feedback' }

    it 'loads the redirect view' do
      subject.css('meta @content').first.text.must_equal('0; url=/contact/')
      subject.css('a @href').first.text.must_equal('/contact/')
    end
  end
end
