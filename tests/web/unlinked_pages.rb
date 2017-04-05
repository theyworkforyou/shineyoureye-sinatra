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
