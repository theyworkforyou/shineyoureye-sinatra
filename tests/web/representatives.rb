# frozen_string_literal: true

require 'test_helper'

describe 'List of Representatives' do
  before { get '/position/federal-representatives/' }
  subject { Nokogiri::HTML(last_response.body) }

  it 'shows the title' do
    subject.css('.page-title').text.must_include('House of Representatives')
  end

  describe 'person list' do
    it 'lists all representatives' do
      subject.css('.contact-list__item').count.must_equal(360)
    end

    it 'groups representatives by state' do
      subject.css('.contact-list').count.must_equal(37)
    end

    it 'displays states alphabetically, from A to Z' do
      subject.css('.contact-list').first.previous_element.text
             .must_equal('Abia')
      subject.css('.contact-list').last.previous_element.text
             .must_equal('Zamfara')
    end

    let(:state) { subject.css('.contact-list').first }

    it 'displays representatives alphabetically inside each state' do
      state.css('.contact-list__item').count.must_equal(8)
      state.css('.col-md-4').first.attr('id')
           .must_equal('benjamin-kalu')
      state.css('.col-md-4').last.attr('id')
           .must_equal('uko-ndokwe-nkole')
    end
  end

  describe 'person item' do
    let(:person) { subject.css('#abdukadir-rahis').first }

    it 'links to the person page' do
      person.css('.contact-list__item__photo').first.parent.attr('href')
            .must_equal('/person/abdukadir-rahis/')
      person.css('.contact-list__item__name').first.parent.attr('href')
            .must_equal('/person/abdukadir-rahis/')
    end

    describe 'when person has an image' do
      it 'points to the right path' do
        person.css('.contact-list__item__photo/@src').first.text
              .must_include('/b2a7f72a-9ecf-4263-83f1-cb0f8783053c/100x100.jpeg')
      end

      it 'has an srcset' do
        person.css('.contact-list__item__photo/@srcset').first.text
              .must_include('/b2a7f72a-9ecf-4263-83f1-cb0f8783053c/100x100.jpeg')
      end

      it 'has the name as alternative text' do
        person.css('.contact-list__item__photo/@alt').first.text
              .must_equal('Abdukadir Rahis')
      end
    end

    describe 'when person does not have an image' do
      let(:person) { subject.xpath('//li[.//div[@class="contact-list__item contact-list__item--people"][.//h3[text()="Sam Onwuaso"]]]') }

      it 'shows a picture anyway (empty avatar)' do
        person.css('.contact-list__item__photo/@src').first.text
              .must_include('/images/person-250x250.png')
      end
    end

    it 'displays the representative name' do
      person.css('.contact-list__item__name').text.must_equal('Abdukadir Rahis')
    end

    it 'links to area page' do
      person.css('.test-area/@href').text.must_equal('/place/maiduguri-metropolitan/')
    end

    it 'displays area name' do
      person.css('.test-area').text.must_equal('Maiduguri (Metropolitan)')
    end

    it 'displays party name' do
      person.css('.test-party').text.must_equal('All Progressives Congress')
    end
  end
end
