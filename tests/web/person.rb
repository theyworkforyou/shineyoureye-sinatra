# frozen_string_literal: true
require 'test_helper'

describe 'Person Page' do
  before { get '/person/b2a7f72a-9ecf-4263-83f1-cb0f8783053c/' }
  subject { Nokogiri::HTML(last_response.body) }

  it 'displays a title' do
    subject.css('title').text.must_include('ABDUKADIR RAHIS')
  end

  it 'displays the position' do
    subject.css('.person__key-info h2').first.text.must_equal('Representative')
  end

  it 'shows the person name' do
    subject.css('h1.person__name').text.must_equal('ABDUKADIR RAHIS')
  end

  describe 'when person has an image' do
    it 'points to the right path' do
      subject.css('img.person__image/@src').first.text
        .must_equal('https://theyworkforyou.github.io/shineyoureye-images/Representatives/b2a7f72a-9ecf-4263-83f1-cb0f8783053c/250x250.jpeg')
    end

    it 'displays the name as alternative text' do
      subject.css('img.person__image/@alt').first.text.must_equal('ABDUKADIR RAHIS')
    end
  end

  describe 'when subject does not have an image' do
    before { get '/person/764fce72-c12a-42ad-ba84-d899f81f7a77/' }

    it 'shows a picture anyway (empty avatar)' do
      # n.b. at the moment we just have a copy of the avatar image;
      # once
      # https://github.com/everypolitician-scrapers/nigeria-national-assembly/issues/10
      # is dealt with we can make this test more helpful.
      subject.css('img.person__image/@src').first.text
        .must_equal('https://theyworkforyou.github.io/shineyoureye-images/Representatives/764fce72-c12a-42ad-ba84-d899f81f7a77/250x250.jpeg')
    end
  end

  describe 'when person has an area' do
    it 'links to the area page' do
      subject.css('.person__area a/@href').first.text.must_equal('/place/maiduguri/')
    end

    it 'displays the area name' do
      subject.css('.person__area a').first.text.must_equal('Maiduguri (Metropolitan)')
    end
  end

  it 'links to the party page' do
    subject.css('.person__party a/@href').first.text.must_equal('/organisation/apc/')
  end

  it 'displays the party name' do
    subject.css('.person__party a').first.text.must_equal('All Progressives Congress')
  end

  describe 'summary section' do
    before { get '/person/0baa5a03-b1e0-4e66-b3f9-daee8bacb87d/' }

    it 'edit link points to the right person id' do
      subject.css('.person-edit-link/@href').text
        .must_include('/summaries/0baa5a03-b1e0-4e66-b3f9-daee8bacb87d.md')
    end

    it 'shows summary contents if person has summary' do
      subject.css('.person-summary li').last.text
        .must_include('Student at LEA PRI.SCH. from 1969 to 1974')
    end
  end

  describe 'when person has no summary' do
    it 'edit link points to the right person id' do
      subject.css('.person-edit-link/@href').text
        .must_include('/summaries/b2a7f72a-9ecf-4263-83f1-cb0f8783053c.md')
    end

    it 'shows nothing in the summary' do
      subject.css('.person-summary').text.strip.must_equal('')
    end
  end

  describe 'when requesting a senator page' do
    before { get '/person/6b0cdd74-7960-478f-ac93-d230f486a5b9/' }

    it 'finds the senator by id' do
      subject.css('title').text.must_include('ABARIBE ENYNNAYA')
    end

    it 'displays the right position' do
      subject.css('.person__key-info h2').first.text.must_equal('Senator')
    end
  end

  describe 'if person id does not exist in this legislature' do
    before { get '/person/i-do-not-exist/' }

    it 'shows a 404 page' do
      subject.css('h1').first.text.must_equal('Not Found')
    end
  end

  describe 'social block' do
    it 'links to facebook share' do
      subject.css('.btn-facebook/@href').text.must_include('/person/b2a7f72a-9ecf-4263-83f1-cb0f8783053c/&t=ABDUKADIR RAHIS')
    end

    it 'links to twitter share' do
      subject.css('.btn-twitter/@href').text.must_include('NGShineyoureye')
      subject.css('.btn-twitter/@href').text.must_include('&text=ABDUKADIR RAHIS')
      subject.css('.btn-twitter/@href').text.must_include('/person/b2a7f72a-9ecf-4263-83f1-cb0f8783053c/')
    end
  end
end
