# frozen_string_literal: true
require 'test_helper'

describe 'The ID <-> slugs CSV file' do
  before { get '/ids-and-slugs.csv' }
  subject { CSV.parse(last_response.body) }

  it 'must have a header row' do
    subject.first.must_equal(%w(id slug))
  end

  it 'must have a slug for a Representative from EP data' do
    assert(subject.include?(['007d807d-2f2d-4a2e-829f-1fd5109bb7de', 'tijjani-jobe-abdulkadir']))
  end

  it 'must have a slug for a Senator from EP data' do
    assert(subject.include?(['0577f346-e883-4e1d-94eb-e3050d5c15f1', 'fatimat-raji-rasaki']))
  end

  it 'must have a slug specified in extra-slugs.csv' do
    assert(subject.include?(['0b536a2c-2bc9-46a0-8d40-0deb9241cb31', 'ahmad-abubakar']))
  end
end
