# frozen_string_literal: true

require 'test_helper'

describe 'Homepage' do
  before  { get '/' }
  subject { Nokogiri::HTML(last_response.body) }

  describe 'featured people' do
    let(:person) { subject.css('.homepage__reps__rep').first }

    it 'displays the person medium size image' do
      person.css('img/@src').text
            .must_include('250x250.jpeg')
    end

    it 'displays all types of people' do
      subject.css('.homepage__reps__rep .btn-default').map(&:text).map(&:strip).uniq.sort
             .must_equal(%w[Governors Representatives Senators])
    end

    it 'displays link to Governors' do
      person.css('.btn-default/@href').text.must_equal('/position/executive-governor/')
    end

    it 'displays the Governors label' do
      person.css('.btn-default').text.strip.must_equal('Governors')
    end

    it 'displays link to Senators' do
      subject.css('.homepage__reps__rep .btn-default/@href')[10].text
             .must_equal('/position/senator/')
    end

    it 'displays the Senators label' do
      subject.css('.homepage__reps__rep .btn-default')[10].text.strip
             .must_equal('Senators')
    end

    it 'displays link to Representatives' do
      subject.css('.homepage__reps__rep .btn-default/@href')[20].text
             .must_equal('/position/representative/')
    end

    it 'displays the Representatives label' do
      subject.css('.homepage__reps__rep .btn-default')[20].text.strip
             .must_equal('Representatives')
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
