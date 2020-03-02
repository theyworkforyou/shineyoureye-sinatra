# frozen_string_literal: true

require 'test_helper'

describe 'Senate' do
  before { get '/position/senator/' }
  subject { Nokogiri::HTML(last_response.body) }

  it 'shows the title' do
    subject.css('.page-title').text.must_include('Senators')
  end

  describe 'person list' do
    it 'lists all senators' do
      subject.css('.contact-list__item').count.must_equal(107)
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

    it 'displays senators alphabetically inside each state' do
      state.css('.contact-list__item').count.must_equal(3)
      state.css('.col-lg-4').first.attr('id')
           .must_equal('abaribe-enyinnaya-harcourt')
      state.css('.col-lg-4').last.attr('id')
           .must_equal('theodore-ahamefule-orji')
    end
  end

  describe 'person item' do
    let(:person) { subject.css('#theodore-ahamefule-orji').first }

    it 'links to the person page' do
      person.css('.contact-list__item__photo').first.parent.attr('href')
            .must_equal('/person/theodore-ahamefule-orji/')
      person.css('.contact-list__item__name').first.parent.attr('href')
            .must_equal('/person/theodore-ahamefule-orji/')
    end

    describe 'when person has an image' do
      it 'points to the right path' do
        person.css('.contact-list__item__photo/@src').first.text
              .must_include('/73f394c3-b0ae-4154-b86c-8e5b7b637df8/100x100.jpeg')
      end

      it 'has an srcset' do
        person.css('.contact-list__item__photo/@srcset').first.text
              .must_include('/73f394c3-b0ae-4154-b86c-8e5b7b637df8/100x100.jpeg')
      end

      it 'has the name as alternative text' do
        person.css('.contact-list__item__photo/@alt').first.text
              .must_equal('Theodore Ahamefule Orji')
      end
    end

    describe 'when person does not have an image' do
      let(:person) { subject.xpath('//li[.//div[@class="contact-list__item contact-list__item--people"][.//h3[text()="Abu Damri"]]]') }

      it 'shows a picture anyway (empty avatar)' do
        person.css('.contact-list__item__photo/@src').first.text
              .must_include('/images/person-250x250.png')
      end
    end

    it 'displays the representative name' do
      person.css('.contact-list__item__name').text.must_equal('Theodore Orji')
    end

    it 'links to area page' do
      person.css('.test-area/@href').text.must_equal('/place/abia-central/')
    end

    it 'displays area name' do
      person.css('.test-area').text.must_equal('Abia Central')
    end

    it 'displays party name' do
      person.css('.test-party').text.must_equal('Peoples Democratic Party')
    end
  end

  describe 'principal person list' do
    it 'lists all senate leaders' do
      subject.css('.people-list__item').count.must_equal(10)
    end

    let(:people) { subject.css('.people-list').first }

    it 'displays senators by their leadership ranks' do
      people.css('.people-list__item').count.must_equal(10)
      people.css('.col-lg-4').first.attr('id')
            .must_equal('lawan-ahmad-ibrahim')
      people.css('.col-lg-4').last.attr('id')
            .must_equal('sahabi-yau')
    end
  end

  describe 'principal person item' do
    let(:person) { subject.css('#ovie-omo-agege').first }

    it 'links to the person page' do
      person.css('.people-list__item__photo').first.parent.attr('href')
            .must_equal('/person/ovie-omo-agege/')
      person.css('.people-list__item__name').first.parent.attr('href')
            .must_equal('/person/ovie-omo-agege/')
    end

    describe 'when person has an image' do
      it 'points to the right path' do
        person.css('.people-list__item__photo/@src').first.text
              .must_include('/af00a81c-21e0-49f9-b61b-e90b36fc8ba1/100x100.jpeg')
      end

      it 'has an srcset' do
        person.css('.people-list__item__photo/@srcset').first.text
              .must_include('/af00a81c-21e0-49f9-b61b-e90b36fc8ba1/100x100.jpeg')
      end

      it 'has the name as alternative text' do
        person.css('.people-list__item__photo/@alt').first.text
              .must_equal('Ovie Omo-Agege')
      end
    end

    it 'displays the representative name' do
      person.css('.people-list__item__name').text.must_equal('Ovie Omo-Agege')
    end

    it 'links to area page' do
      person.css('.test-area/@href').text.must_equal('/place/delta-central/')
    end

    it 'displays area name' do
      person.css('.test-area').text.must_equal('Delta Central')
    end

    it 'displays leadership position' do
      person.css('.test-position').text.must_equal('Deputy Senate President')
    end
  end
end
