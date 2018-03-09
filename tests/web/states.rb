# frozen_string_literal: true

require 'test_helper'

describe 'States Page' do
  before { get '/place/is/state/' }
  subject { Nokogiri::HTML(last_response.body) }

  it 'shows the title' do
    subject.css('div h2').first.text.must_equal('States')
  end

  it 'adds an active class to its nav item' do
    subject.css('.active a/@href').text.must_equal('/place/is/state/')
  end

  it 'shows all states' do
    subject.css('.media').count.must_equal(37)
  end

  it 'links to each state page' do
    subject.css('.media-left a/@href').first.text.must_equal('/place/abia/')
    subject.css('.media-body a/@href').first.text.must_equal('/place/abia/')
  end

  it 'shows each state name' do
    subject.css('.media-heading').last.text.must_equal('Zamfara')
  end

  it 'does not show parent information' do
    assert_empty(subject.css('.parent-place'))
  end

  it 'shows the place type' do
    subject.css('.kind p').first.text.must_equal('State')
  end

  it 'does not show the legislature name nor the term start year' do
    place_item = subject.css('.media').first
    place_item.css('.kind p').count.must_equal(1)
  end
end
