# frozen_string_literal: true

require 'test_helper'

describe 'Homepage' do
  before  { get '/' }
  subject { Nokogiri::HTML(last_response.body) }

  describe 'featured people' do
    let(:person) { subject.css('.homepage__reps__rep').last }

    it 'links to the person page' do
      person.css('a/@href').first.text
            .must_equal('/person/abdukadir-rahis/')
    end

    it 'displays the person medium size image' do
      person.css('img/@src').text
            .must_include('/b2a7f72a-9ecf-4263-83f1-cb0f8783053c/250x250.jpeg')
    end

    it 'displays the person name' do
      person.css('p strong').text.must_equal('ABDUKADIR RAHIS')
    end

    it 'displays the person party name' do
      person.css('p').text.must_include('All Progressives Congress')
    end

    it 'displays the person area name' do
      person.css('p').text.must_include('Maiduguri (Metropolitan)')
    end

    it 'displays all types of people' do
      subject.css('.homepage__reps__rep .btn-default').count.must_equal(3)
    end

    it 'displays link to Senators' do
      subject.css('.homepage__reps__rep .btn-default/@href')[1].text
             .must_equal('/position/senator/')
    end

    it 'displays the Senators label' do
      subject.css('.homepage__reps__rep .btn-default')[1].text.strip
             .must_equal('Senators')
    end

    it 'displays link to Representatives' do
      person.css('.btn-default/@href').text.must_equal('/position/representative/')
    end

    it 'displays the Representatives label' do
      person.css('.btn-default').text.strip.must_equal('Representatives')
    end
  end

  describe 'twitter widget' do
    it 'links to the site twitter account' do
      subject.css('.twitter-timeline/@href').text.must_include('NGShineYourEye')
    end

    it 'displays the right twitter handle' do
      subject.css('.twitter-timeline').text.must_include('NGShineYourEye')
    end
  end
end
