# frozen_string_literal: true

require 'test_helper'
require_relative '../../lib/document/empty_document'

describe 'Document::EmptyDocument' do
  let(:document) { Document::EmptyDocument.new }

  it 'is not featured' do
    document.featured?.must_equal(false)
  end

  it 'has an empty body' do
    assert_empty(document.body)
  end
end
