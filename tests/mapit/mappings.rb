# frozen_string_literal: true
require 'test_helper'
require_relative '../../lib/mapit/mappings'

describe 'Mapit::Mappings' do
  describe 'FED to STA mappings' do
    let(:fed_to_sta) { new_tempfile('949,16
1091,12'
    ) }
    let(:mappings) { Mapit::Mappings.new(
      fed_to_sta_ids_mapping_filename: fed_to_sta,
      pombola_slugs_to_mapit_ids_filename: 'irrelevant'
    ) }

    it 'can map all constituencies to their state' do
      mappings.fed_to_sta_mapping.count.must_equal(2)
    end

    it 'returns FED to STA mappings as a hash' do
      mappings.fed_to_sta_mapping['949'].must_equal('16')
    end

    it 'returns nil if FED id does not exist' do
      assert_nil(mappings.fed_to_sta_mapping['0'])
    end
  end

  describe 'Mapit ids to Pombola slugs' do
    let(:pombola_to_mapit) { new_tempfile('gwagwaladakuje,949,FED
federal-capital-territory,16,STA
abakalikiizzi,1091,FED
ebonyi,12,STA'
    ) }
    let(:mappings) { Mapit::Mappings.new(
      fed_to_sta_ids_mapping_filename: 'irrelevant',
      pombola_slugs_to_mapit_ids_filename: pombola_to_mapit
    ) }

    it 'can map all mapit ids to their Pombola slug' do
      mappings.mapit_ids_to_pombola_slugs.count.must_equal(4)
    end

    it 'uses the mapit id as key and the slug as value' do
      mappings.mapit_ids_to_pombola_slugs['12'].must_equal('ebonyi')
    end

    it 'returns nil if mapit id does not exist' do
      assert_nil(mappings.mapit_ids_to_pombola_slugs['0'])
    end
  end
end
