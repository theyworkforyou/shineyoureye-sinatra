# frozen_string_literal: true
require 'test_helper'
require_relative '../../app'

describe 'Place People Page' do
  describe 'when requesting a federal constituency' do
    before { get '/place/abakalikiizzi/' }
    subject { Nokogiri::HTML(last_response.body) }

    it 'includes the place header' do
      refute_empty(subject.css('.row').text)
    end

    it 'includes the list of people' do
      refute_empty(subject.css('.media-list--people').text)
    end
  end
end
