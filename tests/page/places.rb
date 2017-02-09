# frozen_string_literal: true
require 'test_helper'
require_relative '../../lib/page/places'

describe 'Page::Places' do
  let(:page) { Page::Places.new('Constituencies', ['foo', 'bar']) }

  it 'has a title' do
    page.title.must_equal('Constituencies')
  end

  it 'has all areas' do
    page.places.count.must_equal(2)
  end
end
