# frozen_string_literal: true

require 'test_helper'

describe 'Federal Constituencies Page' do
  before { get '/place/is/federal-constituency/' }
  subject { Nokogiri::HTML(last_response.body) }

  it 'shows the title' do
    subject.css('div h2').first.text.must_equal('Federal Constituencies (Current)')
  end

  it 'adds an active class to its nav item' do
    subject.css('.active a/@href').text.must_equal('/place/is/federal-constituency/')
  end

  it 'shows all constituencies' do
    subject.css('.media').count.must_equal(360)
  end

  it 'links to each constituency page' do
    subject.css('.media-left a/@href').first.text.must_equal('/place/batagarawa-rimi-charanchi/')
    subject.css('.media-body a/@href').first.text.must_equal('/place/batagarawa-rimi-charanchi/')
  end

  it 'shows each constituency name' do
    subject.css('.media-heading').last.text.must_equal('LAGOS MAINLAND')
  end

  it 'links to each parent place' do
    subject.css('.parent-place a/@href').last.text.must_equal('/place/lagos/')
  end

  it 'shows each parent place name' do
    subject.css('.parent-place a').last.text.must_equal('Lagos')
  end

  it 'shows the place type' do
    subject.css('.kind p').first.text.must_equal('Federal Constituency')
  end

  it 'shows the legislature name' do
    subject.css('.kind p').last.text.must_include('House of Representatives')
  end

  it 'shows the current term start year' do
    subject.css('.kind p').last.text.must_include('2019')
  end
end
