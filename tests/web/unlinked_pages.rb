# frozen_string_literal: true
require 'test_helper'

describe 'The Scraper Start Page' do
  before  { get '/scraper-start-page.html' }
  subject { Nokogiri::HTML(last_response.body) }

  it 'must have a link to the home page' do
    refute_empty(subject.xpath('//a[@href="/"]'))
  end

  it 'must have a link to the Jinja2 template' do
    refute_empty(subject.xpath('//a[@href="/jinja2-template.html"]'))
  end

  it 'must have a link to the old events route' do
    refute_empty(subject.xpath('//a[@href="/info/events"]'))
  end

  it 'must have a link to the old contact route' do
    refute_empty(subject.xpath('//a[@href="/feedback"]'))
  end

  it 'must have links to the old person/contact details route' do
    refute_empty(subject.xpath('//a[@href="/person/abdukadir-rahis/contact_details/"]'))
  end

  it 'must have links to the old person/experience route' do
    refute_empty(subject.xpath('//a[@href="/person/abdukadir-rahis/experience/"]'))
  end

  it 'must have links to the IDs <-> slugs CSV file' do
    refute_empty(subject.xpath('//a[@href="/ids-and-slugs.csv"]'))
  end

  it 'lists all available people' do
    ep = 476
    governors = 36
    subject.xpath('//a[contains(@href, "/contact_details/")]').count.must_equal(ep + governors)
    subject.xpath('//a[contains(@href, "/experience/")]').count.must_equal(ep + governors)
  end

  it 'must have links to the old place/people route' do
    refute_empty(subject.xpath('//a[@href="/place/abia-central/people/"]'))
  end

  it 'must have links to the old place/places route' do
    refute_empty(subject.xpath('//a[@href="/place/abia-central/places/"]'))
  end

  it 'lists all available places' do
    fed = 360
    sen = 109
    sta = 37
    subject.xpath('//a[contains(@href, "/people/")]').count.must_equal(fed + sen + sta)
    subject.xpath('//a[contains(@href, "/places/")]').count.must_equal(fed + sen + sta)
  end

  it 'scrapes unpublished post and event pages since they are unlinked' do
    unpublished = '---
published: false
---'
    Dir.stub :glob, [new_tempfile(unpublished)] do
      get '/scraper-start-page.html'
      refute_empty(subject.xpath('//a[contains(text(), "Unlinked post")]'))
      refute_empty(subject.xpath('//a[contains(text(), "Unlinked event")]'))
    end
  end

  it 'scrapes all info pages, including those unlinked' do
    refute_empty(subject.xpath('//a[contains(text(), "Unlinked infopage")]'))
  end
end

describe 'The Jinja2 Template' do
  before  { get '/jinja2-template.html' }
  subject { Nokogiri::HTML(last_response.body) }

  it 'must have the right <div>s around a Jinja2 include of \'content\'' do
    refute_empty(
      subject.xpath(
        '//div[@id="page"]/div[@class="page-section"] ' \
        '/div[@class="container" and contains(text(), "{% include content %}")]'
      )
    )
  end
end
