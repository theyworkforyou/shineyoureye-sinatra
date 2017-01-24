# frozen_string_literal: true
require 'test_helper'
require_relative '../../app'
require_relative '../../tests/fixtures/mapit_data'

describe 'Federal Constituencies Page' do
  before { get '/place/is/federal-constituency/' }
  subject { Nokogiri::HTML(last_response.body) }

  it 'shows the title' do
    subject.css('div h2').first.text.must_equal('Federal Constituencies (Current)')
  end

  it 'shows all constituencies' do
    subject.css('.media').count.must_equal(2)
  end

  it 'links to each constituency page' do
    subject.css('.media-left a/@href').last.text.must_equal('/place/abakalikiizzi/')
    subject.css('.media-heading/@href').last.text.must_equal('/place/abakalikiizzi/')
    subject.css('.read-more/@href').last.text.must_equal('/place/abakalikiizzi/')
  end

  it 'shows each constituency name' do
    subject.css('.media-heading').last.text.must_equal('Abakaliki/Izzi')
  end

  it 'links to each parent place' do
    subject.css('.media-heading ~ p a/@href').last.text.must_equal('/place/ebonyi/')
  end

  it 'shows each parent place name' do
    subject.css('.media-heading ~ p a').last.text.must_equal('Ebonyi')
  end
end
