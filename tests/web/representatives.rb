# frozen_string_literal: true
require 'test_helper'

describe 'List of Representatives' do
  before { get '/position/representative/' }
  subject { Nokogiri::HTML(last_response.body) }

  it 'shows the title' do
    subject.css('.page-title').text.must_include('Representative')
  end

  describe 'person list' do
    it 'lists all representatives' do
      subject.css('.media').count.must_equal(364)
    end
  end

  describe 'person item' do
    let(:person) { subject.css('.media').first }

    it 'links to the person page' do
      person.css('.media-left a/@href').first.text.must_equal('/person/abdukadir-rahis/')
      person.css('.media-body a/@href').first.text.must_equal('/person/abdukadir-rahis/')
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
      let(:person) { subject.xpath('//li[@class="media"][.//h3[text()="ADAMU KAMALE"]]') }

      it 'shows a picture anyway (empty avatar)' do
        person.css('.media-object/@src').first.text
              .must_include('/images/person-250x250.png')
      end
    end

    it 'displays the representative name' do
      person.css('.media-heading').text.must_equal('ABDUKADIR RAHIS')
    end

    it 'shows right area type name' do
      person.css('.media-body p').first.text.must_include('Federal Constituency')
    end

    it 'links to area page' do
      person.css('.listing__area/@href').text.must_equal('/place/maiduguri/')
    end

    it 'displays area name' do
      person.css('.listing__area').text.must_equal('Maiduguri (Metropolitan)')
    end

    it 'displays party name' do
      person.css('.listing__party').text.must_equal('All Progressives Congress')
    end
  end
end
