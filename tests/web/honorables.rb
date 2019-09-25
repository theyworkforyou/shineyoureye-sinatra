# frozen_string_literal: true

require 'test_helper'

describe 'Honorables Page' do
  before { get '/position/state-representatives/' }
  subject { Nokogiri::HTML(last_response.body) }

  it 'shows the title' do
    subject.css('.page-title').text.must_include('State Houses of Assembly')
  end

  it 'displays states alphabetically, from A to Z' do
    subject.css('.states_and_legislature .media-heading').first.text
           .must_equal('Anambra')
    subject.css('.states_and_legislature .media-heading').last.text
           .must_equal('Ogun')
  end

  it 'groups representatives by state' do
    subject.css('.states_and_legislature').count.must_equal(5)
  end

  describe 'List of a state\'s representatives' do
    before { get '/position/state-representatives/lagos/' }
    subject { Nokogiri::HTML(last_response.body) }

    describe 'person list' do
      it 'lists all honorables in lagos state' do
        honorables_count = 40
        subject.css('.contact-list__item').count.must_equal(honorables_count)
      end

      let(:state) { subject.css('.contact-list').first }

      it 'displays honorables alphabetically inside each state' do
        state.css('.contact-list__item').count.must_equal(40)
        state.css('.col-lg-4').first.attr('id')
             .must_equal('mudashiru-ajayi-obasa')
        state.css('.col-lg-4').last.attr('id')
             .must_equal('sangodara-rotimi')
      end

      describe 'person item' do
        let(:person) { subject.css('#mudashiru-ajayi-obasa').first }

        it 'links to the person page' do
          person.css('.contact-list__item__photo').first.parent.attr('href')
                .must_equal('/person/mudashiru-ajayi-obasa/')
          person.css('.contact-list__item__name').first.parent.attr('href')
                .must_equal('/person/mudashiru-ajayi-obasa/')
        end

        describe 'when person has an image' do
          it 'points to the right path' do
            person.css('.contact-list__item__photo/@src').first.text
                  .must_include('/953a8bd2-61d7-4b7d-befb-5aa3b6c869ff/100x100.jpeg')
          end

          it 'has an srcset' do
            person.css('.contact-list__item__photo/@srcset').first.text
                  .must_include('/953a8bd2-61d7-4b7d-befb-5aa3b6c869ff/100x100.jpeg')
          end

          it 'has the name as alternative text' do
            person.css('.contact-list__item__photo/@alt').first.text
                  .must_equal('Mudashiru Ajayi Obasa')
          end
        end

        describe 'when person does not have an image' do
          let(:person) { subject.xpath('//li[.//div[@class="contact-list__item contact-list__item--people"][.//h3[text()="Adewale Temitope"]]]') }

          it 'shows a picture anyway (empty avatar)' do
            person.css('.contact-list__item__photo/@src').first.text
                  .must_include('/images/person-250x250.png')
          end
        end

        it 'displays the honorable name' do
          person.css('.contact-list__item__name').text.must_equal('Mudashiru Obasa')
        end

        it 'links to area page' do
          person.css('.test-area/@href').text.must_equal('/place/agege/')
        end

        it 'displays area name' do
          person.css('.test-area').text.must_equal('Agege')
        end

        it 'does not displays party name' do
          person.css('.test-party').text.wont_equal('Peoples Democratic Party')
        end
      end
    end
  end
end
