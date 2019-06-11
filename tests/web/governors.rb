# frozen_string_literal: true

require 'test_helper'

describe 'List of Governors' do
  before { get '/position/executive-governor/' }
  subject { Nokogiri::HTML(last_response.body) }

  it 'shows the title' do
    subject.css('.page-title').text.must_include('Executive Governor')
  end

  describe 'person list' do
    it 'lists all governors' do
      subject.css('.contact-list__item').count.must_equal(36)
    end

    it 'groups governors by state' do
      subject.css('.contact-list').count.must_equal(36)
    end

    it 'displays states alphabetically, from A to Z' do
      subject.css('.contact-list').first.previous_element.text
             .must_equal('Abia')
      subject.css('.contact-list').last.previous_element.text
             .must_equal('Zamfara')
    end
  end

  describe 'person item' do
    let(:person) { subject.css('#bello-mattawalle').first }

    it 'links to the person page' do
      person.css('.contact-list__item__photo').first.parent.attr('href')
            .must_equal('/person/bello-mattawalle/')
      person.css('.contact-list__item__name').first.parent.attr('href')
            .must_equal('/person/bello-mattawalle/')
    end

    describe 'when person has an image' do
      it 'points to the right path' do
        person.css('.contact-list__item__photo/@src').first.text
              .must_include('/gov-bello-mattawalle/100x100.jpeg')
      end

      it 'has an srcset' do
        person.css('.contact-list__item__photo/@srcset').first.text
              .must_include('/gov-bello-mattawalle/100x100.jpeg')
      end

      it 'has the name as alternative text' do
        person.css('.contact-list__item__photo/@alt').first.text
              .must_equal('Bello Mattawalle')
      end
    end

    describe 'when person does not have an image' do
      let(:person) { subject.xpath('//li[@class="contact-list__item"][.//h3[text()="Nnaji John"]]') }

      before do
        get '/position/representative/'
      end

      it 'shows a picture anyway (empty avatar)' do
        person.css('.contact-list__item__photo/@src').first.text
              .must_include('/images/person-250x250.png')
      end
    end

    it 'displays the representative name' do
      person.css('.contact-list__item__name').text.must_equal('Bello Mattawalle')
    end

    it 'links to area page' do
      person.css('.test-area/@href').text.must_equal('/place/zamfara/')
    end

    it 'displays area name' do
      person.css('.test-area').text.must_equal('Zamfara')
    end

    it 'displays party name' do
      person.css('.test-party').text.must_equal('Peoples Democratic Party')
    end
  end
end
