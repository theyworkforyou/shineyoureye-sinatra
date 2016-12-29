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
    subject.css('.media').count.must_equal(3)
  end

  it 'links to each constituency page' do
    subject.css('.media-left a/@href').first.text.must_equal('/place/gwagwaladakuje/')
    subject.css('.media-body a/@href').first.text.must_equal('/place/gwagwaladakuje/')
  end

  it 'shows each constituency name' do
    subject.css('.media-heading').last.text.must_equal('Maiduguri (Metropolitan)')
  end

  it 'links to each parent place' do
    subject.css('.parent-place a/@href').last.text.must_equal('/place/borno/')
  end

  it 'shows each parent place name' do
    subject.css('.parent-place a').last.text.must_equal('Borno')
  end
end