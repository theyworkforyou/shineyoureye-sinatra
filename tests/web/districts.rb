# frozen_string_literal: true
require 'test_helper'
require_relative '../../app'

describe 'Senatorial Districts Page' do
  before { get '/place/is/senatorial-district/' }
  subject { Nokogiri::HTML(last_response.body) }

  it 'shows the title' do
    subject.css('div h2').first.text.must_equal('Senatorial Districts (Current)')
  end

  it 'adds an active class to its nav item' do
    subject.css('.active a/@href').text.must_equal('/place/is/senatorial-district/')
  end

  it 'shows all districts' do
    subject.css('.media').count.must_equal(5)
  end

  it 'links to each district page' do
    subject.css('.media-left a/@href').first.text.must_equal('/place/abia-central/')
    subject.css('.media-body a/@href').first.text.must_equal('/place/abia-central/')
  end

  it 'shows each district name' do
    subject.css('.media-heading').last.text.must_equal('ABIA SOUTH')
  end

  it 'links to each parent place' do
    subject.css('.parent-place a/@href').last.text.must_equal('/place/abia/')
  end

  it 'shows each parent place name' do
    subject.css('.parent-place a').last.text.must_equal('Abia')
  end

  it 'shows the place type' do
    subject.css('.kind p').first.text.must_equal('Senatorial District')
  end

  it 'shows the legislature name' do
    subject.css('.kind p').last.text.must_include('Senate')
  end

  it 'shows the current term start year' do
    subject.css('.kind p').last.text.must_include('2015')
  end
end
