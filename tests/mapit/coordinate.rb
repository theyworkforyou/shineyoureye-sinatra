# frozen_string_literal: true
require 'test_helper'
require_relative '../../lib/mapit/coordinate'

describe 'Mapit::Coordinate' do
  let(:coordinate) { Mapit::Coordinate.new(1, 2) }

  it 'has a latitude' do
    coordinate.latitude.must_equal(1)
  end

  it 'has a longitude' do
    coordinate.longitude.must_equal(2)
  end
end
