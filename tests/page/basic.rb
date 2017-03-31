# frozen_string_literal: true
require 'test_helper'
require_relative '../../lib/page/basic'

describe 'Page::Basic' do
  let(:page) { Page::Basic.new(title: 'A Title') }

  it 'has a title' do
    page.title.must_equal('A Title')
  end
end
