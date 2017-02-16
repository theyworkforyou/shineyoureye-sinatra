# frozen_string_literal: true
require 'test_helper'
require_relative '../../app'

describe 'List of Representatives' do
  before { get '/position/representative/' }
  subject { Nokogiri::HTML(last_response.body) }

  it 'shows the title' do
    subject.css('.page-title').text.must_include('Representative')
  end

  describe 'person list' do
    it 'lists all representatives' do
      subject.css('.media').count.must_equal(362)
    end
  end

  describe 'person item' do
    let(:person) { subject.css('.media').first }

    it 'links to the person page' do
      person.css('.media-left a/@href').first.text.must_equal('/person/b2a7f72a-9ecf-4263-83f1-cb0f8783053c/')
      person.css('.media-body a/@href').first.text.must_equal('/person/b2a7f72a-9ecf-4263-83f1-cb0f8783053c/')
    end

    describe 'when person has an image' do
      it 'points to the right path' do
        person.css('a img/@src').first.text
          .must_include('/b2a7f72a-9ecf-4263-83f1-cb0f8783053c/100x100.jpeg')
      end

      it 'has an srcset' do
        person.css('a img/@srcset').first.text
          .must_include('/b2a7f72a-9ecf-4263-83f1-cb0f8783053c/100x100.jpeg')
      end

      it 'has the name as alternative text' do
        person.css('a img/@alt').first.text.must_equal('ABDUKADIR RAHIS')
      end
    end

    describe 'when person does not have an image' do
      let(:person) { subject.css('.media')[2] }

      it 'shows a picture anyway (empty avatar)' do
        person.css('a img/@src').first.text
          .must_include('/764fce72-c12a-42ad-ba84-d899f81f7a77/100x100.jpeg')
      end
    end

    it 'displays the representative name' do
      person.css('.media-heading').text.must_equal('ABDUKADIR RAHIS')
    end

    it 'links to area page' do
      person.css('.listing__area/@href').text.must_equal('/place/maiduguri/')
    end

    it 'displays area name' do
      person.css('.listing__area').text.must_equal('Maiduguri (Metropolitan)')
    end

    it 'links to party page' do
      person.css('.listing__party/@href').text.must_equal('/organisation/apc/')
    end

    it 'displays party name' do
      person.css('.listing__party').text.must_equal('All Progressives Congress')
    end
  end
end
