# frozen_string_literal: true

require 'test_helper'

describe 'Senate' do
  before { get '/position/senator/' }
  subject { Nokogiri::HTML(last_response.body) }

  it 'shows the title' do
    subject.css('.page-title').text.must_include('Senator')
  end

  describe 'person list' do
    it 'lists all senators' do
      subject.css('.contact-list__item').count.must_equal(108)
    end

    it 'groups senators by state' do
      subject.css('.contact-list').count.must_equal(37)
    end

    it 'displays states alphabetically, from A to Z' do
      subject.css('.contact-list').first.previous_element.text
             .must_equal('Abia')
      subject.css('.contact-list').last.previous_element.text
             .must_equal('Zamfara')
    end

    let(:state) { subject.css('.contact-list').first }

    it 'displays governors alphabetically inside each state' do
      state.css('.contact-list__item').count.must_equal(3)
      state.css('.contact-list__item').first.attr('id')
           .must_equal('abaribe-enyinnaya-harcourt')
      state.css('.contact-list__item').last.attr('id')
           .must_equal('theodore-ahamefule-orji')
    end
  end

  describe 'person item' do
    let(:person) { subject.css('#abaribe-enyinnaya-harcourt').first }

    it 'links to the person page' do
      person.css('.contact-list__item__photo').first.parent.attr('href')
            .must_equal('/person/abaribe-enyinnaya-harcourt/')
      person.css('.contact-list__item__name').first.parent.attr('href')
            .must_equal('/person/abaribe-enyinnaya-harcourt/')
    end

    describe 'when person has an image' do
      it 'points to the right path' do
        person.css('.contact-list__item__photo/@src').first.text
              .must_include('/6b0cdd74-7960-478f-ac93-d230f486a5b9/100x100.jpeg')
      end

      it 'has an srcset' do
        person.css('.contact-list__item__photo/@srcset').first.text
              .must_include('/6b0cdd74-7960-478f-ac93-d230f486a5b9/100x100.jpeg')
      end

      it 'has the name as alternative text' do
        person.css('.contact-list__item__photo/@alt').first.text
              .must_equal('Abaribe Enyinnaya Harcourt')
      end
    end

    describe 'when person does not have an image' do
      let(:person) { subject.xpath('//li[@class="contact-list__item"][.//h3[text()="Abu Makau Damri"]]') }

      it 'shows a picture anyway (empty avatar)' do
        person.css('.contact-list__item__photo/@src').first.text
              .must_include('/images/person-250x250.png')
      end
    end

    it 'displays the representative name' do
      person.css('.contact-list__item__name').text.must_equal('Abaribe Enyinnaya Harcourt')
    end

    it 'links to area page' do
      person.css('.test-area/@href').text.must_equal('/place/abia-south/')
    end

    it 'displays area name' do
      person.css('.test-area').text.must_equal('Abia South')
    end

    it 'displays party name' do
      person.css('.test-party').text.must_equal('Peoples Democratic Party')
    end
  end
end
