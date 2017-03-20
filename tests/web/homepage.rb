# frozen_string_literal: true
require 'test_helper'

describe 'Homepage' do
  before  { get '/' }
  subject { Nokogiri::HTML(last_response.body) }

  describe 'featured people' do
    let(:person) { subject.css('.homepage__reps__rep').last }

    it 'links to the person page' do
      person.css('a/@href').first.text
            .must_equal('/person/ed60d392-ebe6-49f6-8174-10eb29dbb216/')
    end

    it 'displays the person medium size image' do
      person.css('img/@src').text
            .must_include('/ed60d392-ebe6-49f6-8174-10eb29dbb216/250x250.jpeg')
    end

    it 'displays the person name' do
      person.css('p strong').text.must_equal('LAWALI HASSAN')
    end

    it 'displays the person party name' do
      person.css('p').text.must_include('All Progressives Congress')
    end

    it 'displays the person area name' do
      person.css('p').text.must_include('ANKA//TALATA-MAFARA')
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
end
