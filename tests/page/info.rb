# frozen_string_literal: true
require 'test_helper'
require_relative '../../lib/page/info'

describe 'Page::Info' do
  let(:page) { Page::Info.new }

  it 'has a title' do
    page.title.must_equal('')
  end
end
