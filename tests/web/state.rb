# frozen_string_literal: true
require 'test_helper'

describe 'State Place Page' do
  before { get '/place/abia/' }
  subject { Nokogiri::HTML(last_response.body) }

  # describe 'map' do
  # end

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
      subject.css('.btn-twitter/@href').text.must_include('NGShineyoureye')
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
end
