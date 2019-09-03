# frozen_string_literal: true

require 'test_helper'

describe 'State Place Page' do
  before do
    get_from_disk(geojson_json_url(2), geojson_json)
    get_from_disk(geometry_json_url(2), geometry_json)
    get '/place/abia/'
  end

  subject { Nokogiri::HTML(last_response.body) }

  describe 'map' do
    it 'shows the map' do
      refute_empty(subject.css('#map-canvas'))
    end
  end

  describe 'social block' do
    it 'displays the place name' do
      subject.css('.panel-title').text.must_equal('Abia')
    end

    it 'links to facebook share' do
      subject.css('.btn-facebook/@href').text.must_include('/place/abia/&t=Abia')
    end

    it 'links to twitter share' do
      subject.css('.btn-twitter/@href').text.must_include('NGShineYourEye')
      subject.css('.btn-twitter/@href').text.must_include('&text=Abia')
      subject.css('.btn-twitter/@href').text.must_include('/place/abia/')
    end
  end

  it 'displays the title' do
    subject.css('.person__name').first.text.must_equal('Abia')
  end

  it 'displays the place type name' do
    subject.css('.person__key-info h2').first.text.must_include('State')
  end

  it 'does not display the house name' do
    subject.css('.person__key-info h2').first.text.split('(').count.must_equal(1)
  end

  it 'throws a 404 error if no area is found for a slug' do
    get '/place/i-dont-exist/'
    subject.css('h1').first.text.must_equal('Not Found')
  end

  describe 'person item' do
    let(:person) { subject.css('.contact-list__item').first }

    it 'links to the person page' do
      person.css('.contact-list__item__photo').first.parent.attr('href')
            .must_equal('/person/okezie-ikpeazu/')
      person.css('.contact-list__item__name').first.parent.attr('href')
            .must_equal('/person/okezie-ikpeazu/')
    end

    it 'has an image that points to the thumbnail proxy image' do
      person.css('.contact-list__item__photo/@src').text
            .must_include('/gov:victor-okezie-ikpeazu/100x100.jpeg')
    end

    it 'has an image whose srcset that points to the thumbnail proxy image' do
      person.css('.contact-list__item__photo/@srcset').text
            .must_include('/gov:victor-okezie-ikpeazu/100x100.jpeg')
    end

    it 'has an image whose alternative text is the person name' do
      person.css('.contact-list__item__photo/@alt').text
            .must_equal('Okezie Ikpeazu')
    end

    it 'displays the person name' do
      person.css('.contact-list__item__name').first.text
            .must_equal('Okezie Ikpeazu')
    end

    it 'links to the person area' do
      person.css('.test-area @href').text
            .must_equal('/place/abia/')
    end

    it 'displays the person area name' do
      person.css('.test-area').text
            .must_equal('Abia')
    end

    it 'displays the person party name' do
      person.css('.test-party').text
            .must_equal('Peoples Democratic Party')
    end
  end
end
