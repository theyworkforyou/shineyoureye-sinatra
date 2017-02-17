# frozen_string_literal: true
require 'test_helper'
require_relative '../../app'

describe 'Senatorial District Place Page' do
  before { get '/place/abia-central/' }
  subject { Nokogiri::HTML(last_response.body) }

  # describe 'map' do
  # end

  # describe 'key figure' do
  # end

  describe 'social block' do
    it 'displays the place name' do
      subject.css('.panel-title').text.must_equal('ABIA CENTRAL')
    end

    it 'links to facebook share' do
      subject.css('.btn-facebook/@href').text.must_include('/place/abia-central/&t=ABIA CENTRAL')
    end

    it 'links to twitter share' do
      subject.css('.btn-twitter/@href').text.must_include('NGShineyoureye')
      subject.css('.btn-twitter/@href').text.must_include('&text=ABIA CENTRAL')
      subject.css('.btn-twitter/@href').text.must_include('/place/abia-central/')
    end
  end

  it 'displays the title' do
    subject.css('.person__name').first.text.must_equal('ABIA CENTRAL')
  end

  it 'displays the place type name' do
    subject.css('.person__key-info h2').first.text
    .must_include('Senatorial District')
  end

  it 'displays the house name' do
    subject.css('.person__key-info h2').first.text
    .must_include('Senate')
  end

  it 'displays all people associated with the place' do
    subject.css('.media-list--people .media').count.must_equal(1)
  end

  describe 'person item' do
    let(:person) { subject.css('.media-list--people .media').first }

    it 'links to the person page' do
      person.css('.media-left a/@href').text
      .must_equal('/person/73f394c3-b0ae-4154-b86c-8e5b7b637df8/')
      person.css('.media-body a/@href').first.text
      .must_equal('/person/73f394c3-b0ae-4154-b86c-8e5b7b637df8/')
    end

    it 'has an image that points to the thumbnail proxy image' do
      person.css('.media-left img/@src').text
      .must_include('/73f394c3-b0ae-4154-b86c-8e5b7b637df8/100x100.jpeg')
    end

    it 'has an image whose srcset that points to the thumbnail proxy image' do
      person.css('.media-left img/@srcset').text
      .must_include('/73f394c3-b0ae-4154-b86c-8e5b7b637df8/100x100.jpeg')
    end

    it 'has an image whose alternative text is the person name' do
      person.css('.media-left img/@alt').text
      .must_equal('THEODORE ORJI')
    end

    it 'displays the person name' do
      person.css('.media-body a').first.text
      .must_equal('THEODORE ORJI')
    end

    it 'shows right area type name' do
      person.css('.media-body p').first.text.must_include('Senatorial District')
    end

    it 'links to the person area' do
      person.css('.listing__area @href').text
      .must_equal('/place/abia-central/')
    end

    it 'displays the person area name' do
      person.css('.listing__area').text
      .must_equal('ABIA CENTRAL')
    end

    it 'links to the person party' do
      person.css('.listing__party @href').text
      .must_equal('/organisation/pdp/')
    end

    it 'displays the person party name' do
      person.css('.listing__party').text
      .must_equal('Peoples Democratic Party')
    end
  end
end
