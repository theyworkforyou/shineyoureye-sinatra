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

  it 'displays the person name' do
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

  describe 'when person does not have an image' do
    before { get '/person/78a5c98d-8bbb-45ec-8faa-937d77a93191/' }

    it 'shows a picture anyway (empty avatar)' do
      subject.css('img.person__image/@src').first.text
             .must_equal('/images/person-250x250.png')
    end
  end

  describe 'when person has an area' do
    it 'shows the area type name' do
      subject.css('.person__key-info h2').text
             .must_include('Federal Constituency')
    end

    it 'links to the area page' do
      subject.css('.person__area a/@href').first.text
             .must_equal('/place/maiduguri/')
    end

    it 'displays the area name' do
      subject.css('.person__area a').first.text
             .must_equal('Maiduguri (Metropolitan)')
    end
  end

  it 'displays the party name' do
    subject.css('.person__party').first.text.must_equal('All Progressives Congress')
  end

  describe 'when person has a birth date' do
    before { get '/person/007d807d-2f2d-4a2e-829f-1fd5109bb7de/' }

    it 'displays it' do
      subject.css('.person__birthdate').first.text.must_equal('1970-01-02')
    end
  end

  describe 'when person has a phone' do
    it 'displays it' do
      subject.css('.person__phone').first.text.must_equal('08083999997')
    end
  end

  describe 'when person has a Twitter' do
    before { get '/person/13721811-4357-419c-8ca7-8f1170b36f1a/' }

    it 'links to it' do
      subject.css('.person__twitter a/@href').first.text
             .must_equal('https://twitter.com/benmurraybruce')
    end

    it 'displays it' do
      subject.css('.person__twitter a').first.text.must_equal('@benmurraybruce')
    end
  end

  describe 'when person has a Facebook' do
    before { get '/person/gov:willie-obiano/' }

    it 'links to it' do
      subject.css('.person__facebook a/@href').first.text
             .must_equal('https://www.facebook.com/WillieObiano')
    end

    it 'displays it' do
      subject.css('.person__facebook a').first.text.must_equal('WillieObiano')
    end
  end

  describe 'when person has an email' do
    before { get '/person/9de46243-685e-4902-81d4-b3e01faa93d5/' }

    it 'links to the email' do
      subject.css('.person__email a/@href').first.text
             .must_equal('mailto:adamu.abdullahi@gmail.com')
    end

    it 'displays the email' do
      subject.css('.person__email a').first.text
             .must_equal('adamu.abdullahi@gmail.com')
    end
  end

  describe 'when person has wikipedia url' do
    before { get '/person/0577f346-e883-4e1d-94eb-e3050d5c15f1/' }

    it 'links to it' do
      subject.css('.person__wikipedia a/@href').first.text
             .must_equal('https://en.wikipedia.org/wiki/Fatimat_Olufunke_Raji-Rasaki')
    end

    it 'displays it' do
      subject.css('.person__wikipedia a').first.text
             .must_equal('https://en.wikipedia.org/wiki/Fatimat_Olufunke_Raji-Rasaki')
    end
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
      get '/person/gov:abdulaziz-abubakar-yari/'
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

  describe 'when requesting a governor page' do
    before { get '/person/gov:victor-okezie-ikpeazu/' }

    it 'finds the governor by slug' do
      subject.css('title').text.must_include('Victor Okezie Ikpeazu')
    end

    it 'displays the right position' do
      subject.css('.person__key-info h2').first.text.must_equal('Governor')
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
      subject.css('.btn-facebook/@href').text.must_include(
        '/person/b2a7f72a-9ecf-4263-83f1-cb0f8783053c/&t=ABDUKADIR RAHIS'
      )
    end

    it 'links to twitter share' do
      subject.css('.btn-twitter/@href').text.must_include('NGShineyoureye')
      subject.css('.btn-twitter/@href').text.must_include('&text=ABDUKADIR RAHIS')
      subject.css('.btn-twitter/@href').text.must_include('/person/b2a7f72a-9ecf-4263-83f1-cb0f8783053c/')
    end
  end
end
