# frozen_string_literal: true

require 'test_helper'

describe 'Federal Constituency Place Page' do
  before do
    get_from_disk(geojson_json_url(1091), geojson_json)
    get_from_disk(geometry_json_url(1091), geometry_json)
    get '/place/abakalikiizzi/'
  end

  subject { Nokogiri::HTML(last_response.body) }

  describe 'map' do
    it 'shows the map' do
      refute_empty(subject.css('#map-canvas'))
    end
  end

  describe 'social block' do
    it 'displays the place name' do
      subject.css('.panel-title').text.must_equal('Abakaliki/Izzi')
    end

    it 'links to facebook share' do
      subject.css('.btn-facebook/@href').text.must_include('/place/abakalikiizzi/&t=Abakaliki/Izzi')
    end

    it 'links to twitter share' do
      subject.css('.btn-twitter/@href').text.must_include('NGShineYourEye')
      subject.css('.btn-twitter/@href').text.must_include('&text=Abakaliki/Izzi')
      subject.css('.btn-twitter/@href').text.must_include('/place/abakalikiizzi/')
    end
  end

  it 'displays the title' do
    subject.css('.person__name').first.text.must_equal('Abakaliki/Izzi')
  end

  it 'displays the place type name' do
    subject.css('.person__key-info h2').first.text
           .must_include('Federal Constituency')
  end

  it 'displays the house name' do
    subject.css('.person__key-info h2').first.text
           .must_include('House of Representatives')
  end

  it 'displays all people associated with the place' do
    subject.css('.media-list--people .media').count.must_equal(1)
  end

  describe 'person item' do
    let(:person) { subject.css('.media-list--people .media').first }

    it 'links to the person page' do
      person.css('.media-left a/@href').text
            .must_equal('/person/sylvester-o-ogbaga/')
      person.css('.media-body a/@href').first.text
            .must_equal('/person/sylvester-o-ogbaga/')
    end

    it 'has an image that points to the thumbnail proxy image' do
      person.css('.media-left img/@src').text
            .must_include('/ea083b8f-f370-484e-bb84-63541cd0cc1c/100x100.jpeg')
    end

    it 'has an image whose srcset that points to the thumbnail proxy image' do
      person.css('.media-left img/@srcset').text
            .must_include('/ea083b8f-f370-484e-bb84-63541cd0cc1c/100x100.jpeg')
    end

    it 'has an image whose alternative text is the person name' do
      person.css('.media-left img/@alt').text
            .must_equal('SYLVESTER OGBAGA')
    end

    it 'displays the person name' do
      person.css('.media-body a').first.text
            .must_equal('SYLVESTER OGBAGA')
    end

    it 'shows right area type name' do
      person.css('.media-body p').first.text.must_include('Federal Constituency')
    end

    it 'links to the person area' do
      person.css('.listing__area @href').text
            .must_equal('/place/abakalikiizzi/')
    end

    it 'displays the person area name' do
      person.css('.listing__area').text
            .must_equal('Abakaliki/Izzi')
    end

    it 'displays the person party name' do
      person.css('.listing__party').text
            .must_equal('Peoples Democratic Party')
    end
  end
end
