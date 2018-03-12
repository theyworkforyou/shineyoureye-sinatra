# frozen_string_literal: true

require 'test_helper'

describe 'Generic tests for the place page' do
  subject { Nokogiri::HTML(last_response.body) }

  describe 'when place has no people' do
    before do
      get_from_disk(geojson_json_url(1209), geojson_json)
      get_from_disk(geometry_json_url(1209), geometry_json)
      get '/place/kaduna-north/'
    end

    it 'displays the right house name' do
      subject.css('.person__key-info h2').first.text
             .must_include('House of Representatives')
    end
  end

  describe 'when place does not exist' do
    before { get '/place/i-do-not-exist/' }

    it 'shows a 404 page' do
      subject.css('h1').first.text.must_equal('Not Found')
    end
  end

  describe 'redirection from old route' do
    before do
      get_from_disk(geojson_json_url(809), geojson_json)
      get_from_disk(geometry_json_url(809), geometry_json)
    end

    it 'loads the redirect view for the people route' do
      get '/place/abia-central/people/'
      subject.css('meta @content').first.text.must_equal('0; url=/place/abia-central/')
      subject.css('a @href').first.text.must_equal('/place/abia-central/')
    end

    it 'loads the redirect view for the places route' do
      get '/place/abia-central/places/'
      subject.css('meta @content').first.text.must_equal('0; url=/place/abia-central/')
      subject.css('a @href').first.text.must_equal('/place/abia-central/')
    end
  end
end
