# frozen_string_literal: true
require 'test_helper'
require_relative '../../lib/mapit/place'

describe 'Place' do
  describe 'if area has a parent' do
    let(:place) { Mapit::Place.new(
      place: area_with_parent,
      parent: parent,
      pombola_slug: 'gwagwaladakuje',
      baseurl: '/baseurl/'
    ) }

    it 'knows its id' do
      place.id.must_equal(949)
    end

    it 'knows its name' do
      place.name.must_equal('Abaji/Gwagwalada/Kwali/Kuje')
    end

    it 'knows its parent name' do
      place.parent.name.must_equal('Federal Capital Territory')
    end

    it 'builds the place url with the baseurl' do
      place.url.must_equal('/baseurl/gwagwaladakuje/')
    end

    it 'builds the parent url with the baseurl' do
      place.parent.url.must_equal('/baseurl/federal-capital-territory/')
    end
  end

  describe 'if area has no parent' do
    let(:place) { parent }

    it 'returns nil for the parent' do
      assert_nil(place.parent)
    end
  end

  def area_with_parent
    JSON.parse(FED_JSON).values.first
  end

  def area_with_no_parent
    JSON.parse(STA_JSON).values.first
  end

  def parent
    Mapit::Place.new(
      place: area_with_no_parent,
      parent: nil,
      pombola_slug: 'federal-capital-territory',
      baseurl: '/baseurl/'
    )
  end
end
