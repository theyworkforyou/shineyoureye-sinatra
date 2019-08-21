# frozen_string_literal: true

require 'test_helper'

describe 'Honorables Page' do
  before { get '/position/state-representatives/' }
  subject { Nokogiri::HTML(last_response.body) }

  it 'shows the title' do
    subject.css('.page-title').text.must_include('State Houses of Assembly')
  end

  describe 'person list' do
    it 'lists all honorables' do
      honorables_count = 40 + 26 + 30
      subject.css('.contact-list__item').count.must_equal(honorables_count)
    end

    it 'groups honrables by state' do
      subject.css('.contact-list').count.must_equal(3)
    end

    it 'displays states alphabetically, from A to Z' do
      subject.css('.contact-list').first.previous_element.text
             .must_equal('Anambra')
      subject.css('.contact-list').last.previous_element.text
             .must_equal('Ogun')
    end

    let(:state) { subject.css('.contact-list').first }

    it 'displays honorables alphabetically inside each state' do
      state.css('.contact-list__item').count.must_equal(30)
      state.css('.col-md-4').first.attr('id')
           .must_equal('agbodike-paschal')
      state.css('.col-md-4').last.attr('id')
           .must_equal('umeoduagu-nnamdi-dike')
    end
  end

  describe 'person item' do
    let(:person) { subject.css('#agbodike-paschal').first }

    it 'links to the person page' do
      person.css('.contact-list__item__photo').first.parent.attr('href')
            .must_equal('/person/agbodike-paschal/')
      person.css('.contact-list__item__name').first.parent.attr('href')
            .must_equal('/person/agbodike-paschal/')
    end

    # describe 'when person has an image' do
    #   it 'points to the right path' do
    #     person.css('.contact-list__item__photo/@src').first.text
    #           .must_include('/be9d2146-7a6e-4719-b81c-9a15680ea241/100x100.jpeg')
    #   end

    #   it 'has an srcset' do
    #     person.css('.contact-list__item__photo/@srcset').first.text
    #           .must_include('/be9d2146-7a6e-4719-b81c-9a15680ea241/100x100.jpeg')
    #   end

    #   it 'has the name as alternative text' do
    #     person.css('.contact-list__item__photo/@alt').first.text
    #           .must_equal('Agbodike Paschal')
    #   end
    # end

    describe 'when person does not have an image' do
      let(:person) { subject.xpath('//li[.//div[@class="contact-list__item contact-list__item--people"][.//h3[text()="Emeka Aforka"]]]') }

      it 'shows a picture anyway (empty avatar)' do
        person.css('.contact-list__item__photo/@src').first.text
              .must_include('/images/person-250x250.png')
      end
    end

    it 'displays the representative name' do
      person.css('.contact-list__item__name').text.must_equal('Agbodike Paschal')
    end

    it 'links to area page' do
      person.css('.test-area/@href').text.must_equal('/place/ihiala/')
    end

    it 'displays area name' do
      person.css('.test-area').text.must_equal('Ihiala')
    end

    it 'does not displays party name' do
      person.css('.test-party').text.wont_equal('Peoples Democratic Party')
    end
  end
end
