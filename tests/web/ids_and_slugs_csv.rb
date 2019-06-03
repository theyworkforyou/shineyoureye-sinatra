# frozen_string_literal: true

require 'test_helper'

describe 'The ID <-> slugs CSV file' do
  before { get '/ids-and-slugs.csv' }
  subject { CSV.parse(last_response.body) }

  it 'must have a header row' do
    subject.first.must_equal(%w[id slug])
  end

  it 'must have a slug for a Representative from EP data' do
    assert(subject.include?(['b32bbfd7-7e44-45e3-b1e1-fb5cff750021', 'francis-uduyok']))
  end

  it 'must have a slug for a Senator from EP data' do
    assert(subject.include?(['5744450e-41b7-4d7d-b81a-83f42f34437d', 'tinubu-oluremi']))
  end

  it 'must have a slug specified in extra-slugs.csv' do
    assert(subject.include?(['e5a6c86b-b503-4105-983b-d5c81ab41eaf', 'solomon-olamilekan-adeola']))
  end
end
