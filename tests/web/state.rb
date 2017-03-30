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

  # describe 'key figure' do
  # end

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
    let(:person) { subject.css('.media-list--people .media').first }

    it 'links to the person page' do
      person.css('.media-left a/@href').text
            .must_equal('/person/okezie-ikpeazu/')
      person.css('.media-body a/@href').first.text
            .must_equal('/person/okezie-ikpeazu/')
    end

    it 'has an image that points to the thumbnail proxy image' do
      person.css('.media-left img/@src').text
            .must_include('/gov:victor-okezie-ikpeazu/100x100.jpeg')
    end

    it 'has an image whose srcset that points to the thumbnail proxy image' do
      person.css('.media-left img/@srcset').text
            .must_include('/gov:victor-okezie-ikpeazu/100x100.jpeg')
    end

    it 'has an image whose alternative text is the person name' do
      person.css('.media-left img/@alt').text
            .must_equal('Victor Okezie Ikpeazu')
    end

    it 'displays the person name' do
      person.css('.media-body a').first.text
            .must_equal('Victor Okezie Ikpeazu')
    end

    it 'shows right area type name' do
      person.css('.media-body p').first.text.must_include('State')
    end

    it 'links to the person area' do
      person.css('.listing__area @href').text
            .must_equal('/place/abia/')
    end

    it 'displays the person area name' do
      person.css('.listing__area').text
            .must_equal('Abia')
    end

    it 'displays the person party name' do
      person.css('.listing__party').text
            .must_equal('PDP')
    end
  end
end
