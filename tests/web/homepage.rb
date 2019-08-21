# frozen_string_literal: true

require 'test_helper'

describe 'Homepage' do
  before  { get '/' }
  subject { Nokogiri::HTML(last_response.body) }

  describe 'featured people' do
    let(:governors) { subject.css('.homepage__reps .col-sm-12')[0] }
    let(:senators) { subject.css('.homepage__reps .col-sm-12')[1] }
    let(:representatives) { subject.css('.homepage__reps .col-sm-12')[2] }
    let(:honorables) { subject.css('.homepage__reps .col-sm-12')[3] }

    it 'displays a medium size image for the first person of each type' do
      governors.css('.homepage__reps__rep').first.css('img/@src').text
               .must_include('250x250.jpeg')
      senators.css('.homepage__reps__rep').first.css('img/@src').text
              .must_include('250x250.jpeg')
      representatives.css('.homepage__reps__rep').first.css('img/@src').text
                     .must_include('250x250.jpeg')
      honorables.css('.homepage__reps__rep').first.css('img/@src').text
                .must_include('250x250.jpeg')
    end

    it 'hides all but the first person of each type' do
      governors.css('.homepage__reps__rep/@class')[2].text
               .must_include('hidden')
      governors.css('.homepage__reps__rep img/@src')[2]
               .must_be_nil
      senators.css('.homepage__reps__rep/@class')[4].text
              .must_include('hidden')
      senators.css('.homepage__reps__rep img/@src')[4]
              .must_be_nil
      representatives.css('.homepage__reps__rep/@class')[0].text
                     .wont_include('hidden')
      representatives.css('.homepage__reps__rep img/@src')[0]
                     .wont_be_nil
      honorables.css('.homepage__reps__rep/@class')[4].text
                .must_include('hidden')
      honorables.css('.homepage__reps__rep img/@src')[4]
                .must_be_nil
    end

    it 'displays all types of people' do
      subject.css('.homepage__reps .btn-default').map(&:text).map(&:strip).uniq.sort
             .must_equal(%w[Governors Honorables Representatives Senators])
    end

    it 'displays a link to Governors' do
      governors.css('.btn-default/@href')[0].text
               .must_equal('/position/executive-governor/')
      governors.css('.btn-default')[0].text.strip
               .must_equal('Governors')
    end

    it 'displays a link to Senators' do
      senators.css('.btn-default/@href')[0].text
              .must_equal('/position/senator/')
      senators.css('.btn-default')[0].text.strip
              .must_equal('Senators')
    end

    it 'displays link to Representatives' do
      representatives.css('.btn-default/@href')[0].text
                     .must_equal('/position/federal-representatives/')
      representatives.css('.btn-default')[0].text.strip
                     .must_equal('Representatives')
    end
    it 'displays link to Honorables' do
      honorables.css('.btn-default/@href')[0].text
                .must_equal('/position/state-representatives/')
      honorables.css('.btn-default')[0].text.strip
                .must_equal('Honorables')
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
