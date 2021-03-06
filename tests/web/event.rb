# frozen_string_literal: true

require 'test_helper'

describe 'Event Page' do
  before { get '/events/ordinary-citizens-doing-extraordinary-things' }
  subject { Nokogiri::HTML(last_response.body) }

  it 'shows the event title' do
    subject.css('.page-title').text.must_equal('Ordinary Citizens Doing Extraordinary Things')
  end

  it 'shows the publication date with the right format' do
    subject.css('.meta').first.text.must_equal('June 24, 2019')
  end

  it 'displays the contents of the event' do
    refute_empty(subject.css('.markdown.infopage'))
  end

  it 'throws a 404 error if no file is found' do
    get '/events/i-dont-exist'
    subject = Nokogiri::HTML(last_response.body)
    subject.css('h1').first.text.must_equal('Not Found')
  end
end
