# frozen_string_literal: true
require 'test_helper'
require_relative '../../app'

describe 'Senate' do
  before { get '/position/senator/' }
  subject { Nokogiri::HTML(last_response.body) }

  it 'shows the title' do
    subject.css('.page-title').text.must_include('Senator')
  end

  describe 'person list' do
    it 'lists all senators' do
      subject.css('.media').count.must_equal(108)
    end
  end

  describe 'person item' do
    let(:person) { subject.css('.media').first }

    it 'links to the person page' do
      person.css('.media-left a/@href').first.text.must_equal('/person/6b0cdd74-7960-478f-ac93-d230f486a5b9/')
      person.css('.media-body a/@href').first.text.must_equal('/person/6b0cdd74-7960-478f-ac93-d230f486a5b9/')
    end

    describe 'when person has an image' do
      it 'points to the right path' do
        person.css('a img/@src').first.text.must_include('/6b0cdd74-7960-478f-ac93-d230f486a5b9/100x100.jpeg')
      end

      it 'has an srcset' do
        person.css('a img/@srcset').first.text.must_include('/6b0cdd74-7960-478f-ac93-d230f486a5b9/100x100.jpeg')
      end

      it 'has the name as alternative text' do
        person.css('a img/@alt').first.text.must_equal('ABARIBE ENYNNAYA')
      end
    end

    describe 'when person does not have an image' do
      let(:person) { subject.css('.media')[2] }

      it 'shows a generic picture' do
        person.css('a img/@src').first.text.must_include('/f63fc610-ec4b-4ba0-bf02-b543c5fd8c8f/100x100.jpeg')
      end
    end

    it 'displays the representative name' do
      person.css('.media-heading').text.must_equal('ABARIBE ENYNNAYA')
    end

    it 'shows right area type name' do
      person.css('.media-body p').first.text.must_include('Senatorial District')
    end

    it 'links to area page' do
      person.css('.listing__area/@href').text.must_equal('/place/abia-south/')
    end

    it 'displays area name' do
      person.css('.listing__area').text.must_equal('ABIA SOUTH')
    end

    it 'links to party page' do
      person.css('.listing__party/@href').text.must_equal('/organisation/pdp/')
    end

    it 'displays party name' do
      person.css('.listing__party').text.must_equal('Peoples Democratic Party')
    end
  end
end
