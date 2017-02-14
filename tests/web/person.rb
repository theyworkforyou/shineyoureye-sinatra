# frozen_string_literal: true
require 'test_helper'
require_relative '../../app'

describe 'Person Page' do
  before { get '/person/b2a7f72a-9ecf-4263-83f1-cb0f8783053c/' }
  subject { Nokogiri::HTML(last_response.body) }

  it 'displays a title' do
    subject.css('title').text.must_include('ABDUKADIR RAHIS')
  end

  it 'shows the person name' do
    subject.css('.title-space__name h1').text.must_equal('ABDUKADIR RAHIS')
  end

  describe 'when person has an image' do
    it 'points to the right path' do
      subject.css('.profile-pic img/@src').first.text
        .must_include('/b2a7f72a-9ecf-4263-83f1-cb0f8783053c/140x140.jpeg')
    end

    it 'displays an srcset' do
      subject.css('.profile-pic img/@srcset').first.text
        .must_include('/b2a7f72a-9ecf-4263-83f1-cb0f8783053c/140x140.jpeg')
    end

    it 'displays the name as alternative text' do
      subject.css('.profile-pic img/@alt').first.text.must_equal('ABDUKADIR RAHIS')
    end
  end

  describe 'when subject does not have an image' do
    before { get '/person/764fce72-c12a-42ad-ba84-d899f81f7a77/' }
    subject { Nokogiri::HTML(last_response.body) }

    it 'shows a picture anyway (empty avatar)' do
      subject.css('.profile-pic img/@src').first.text
        .must_include('/764fce72-c12a-42ad-ba84-d899f81f7a77/140x140.jpeg')
    end
  end

  describe 'when person has an area' do
    it 'links to the area page' do
      subject.css('.constituency-party a/@href').first.text.must_equal('/place/maiduguri/')
    end

    it 'displays the area name' do
      subject.css('.constituency-party a').first.text.must_equal('Maiduguri (Metropolitan)')
    end
  end

  it 'links to the party page' do
    subject.css('.party-memberships a/@href').first.text.must_equal('/organisation/apc/')
  end

  it 'displays the party name' do
    subject.css('.party-memberships a').first.text.must_equal('All Progressives Congress')
  end

  describe 'if person id does not exist in this legislature' do
    before { get '/person/i-do-not-exist/' }
    subject { Nokogiri::HTML(last_response.body) }

    it 'shows a 404 page' do
      subject.css('h1').first.text.must_equal('Not Found')
    end
  end

  describe 'social block' do
    it 'links to facebook share' do
      subject.css('.big-btn-text-fb/@href').text.must_include('/person/b2a7f72a-9ecf-4263-83f1-cb0f8783053c/&t=ABDUKADIR RAHIS')
    end

    it 'links to twitter share' do
      subject.css('.big-btn-text-tw/@href').text.must_include('NGShineyoureye')
      subject.css('.big-btn-text-tw/@href').text.must_include('&text=ABDUKADIR RAHIS')
      subject.css('.big-btn-text-tw/@href').text.must_include('/person/b2a7f72a-9ecf-4263-83f1-cb0f8783053c/')
    end

    it 'links to comments' do
      subject.css('.big-btn-text-green/@href').text.must_include('/person/b2a7f72a-9ecf-4263-83f1-cb0f8783053c/#comments')
    end
  end
end
