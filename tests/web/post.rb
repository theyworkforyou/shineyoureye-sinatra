# frozen_string_literal: true

require 'test_helper'

describe 'Post Page' do
  before { get '/blog/nigerian-workers-and-the-struggle-for-new-wage-matters-arising' }
  subject { Nokogiri::HTML(last_response.body) }

  it 'shows the post title' do
    subject.css('.page-title').text.must_equal('Nigerian Workers and the struggle for New Wage: Matters Arising!')
  end

  it 'shows the date with the right format' do
    subject.css('.meta').first.text.must_equal('May 3, 2019')
  end

  it 'displays the contents of the post' do
    subject.css('.markdown.infopage').text.must_include('The celebration of the 2019 edition ')
  end

  it 'throws a 404 error if no file is found' do
    get '/blog/i-dont-exist'
    subject = Nokogiri::HTML(last_response.body)
    subject.css('h1').first.text.must_equal('Not Found')
  end
end
