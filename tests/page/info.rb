# frozen_string_literal: true
require 'test_helper'
require_relative '../../lib/page/info'

describe 'Page::Info' do
  let(:page) { Page::Info.new(static_page: FakeInfo.new) }


  it 'has a title' do
    page.title.must_equal('A Title')
  end

  it 'has a body' do
    page.body.must_include('Hello World')
  end

  class FakeInfo
    def title
      'A Title'
    end

    def body
      'Hello World'
    end
  end
end
