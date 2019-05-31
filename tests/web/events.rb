# frozen_string_literal: true

require 'test_helper'

describe 'Events Page' do
  before { get '/events/' }
  subject { Nokogiri::HTML(last_response.body) }

  it 'shows the title' do
    subject.css('h1').first.text.must_equal('Events')
  end

  it 'shows all events' do
    more_than_one = subject.css('.blog-in-a-list').count >= 1
    more_than_one.must_equal(true)
  end

  describe 'when displaying a event' do
    let(:single_event) { subject.css('.blog-in-a-list').last }

    it 'links to event url' do
      single_event.css('h2 a/@href').text.must_equal('/events/local-government-elections')
    end

    it 'displays event title' do
      single_event.css('h2').text.must_equal('Local Government Elections')
    end

    it 'displays event publication date' do
      single_event.css('.meta').text.must_equal('June 21, 2017')
    end

    it 'displays event excerpt' do
      refute_empty(single_event.css('div'))
    end
  end

  describe 'redirection from old route' do
    before { get '/info/events' }

    it 'loads the redirect view' do
      subject.css('meta @content').first.text.must_equal('0; url=/events/')
      subject.css('a @href').first.text.must_equal('/events/')
    end
  end
end
