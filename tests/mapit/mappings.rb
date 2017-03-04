# frozen_string_literal: true
require 'test_helper'
require_relative '../../lib/mapit/mappings'

describe 'Mapit::Mappings' do
  describe 'FED to STA mappings' do
    let(:fed_to_sta) do
      new_tempfile(
        '949,16
1091,12'
      )
    end
    let(:mappings) do
      Mapit::Mappings.new(parent_mapping_filenames: [fed_to_sta])
    end

    it 'can map all constituencies to their state' do
      mappings.child_to_parent.count.must_equal(2)
    end

    it 'returns FED to STA mappings as a hash' do
      mappings.child_to_parent['949'].must_equal('16')
    end

    it 'returns nil if FED id does not exist' do
      assert_nil(mappings.child_to_parent['0'])
    end

    it 'returns an empty map if no Pombola <-> MapIt mapping is supplied' do
      assert_empty(mappings.pombola_slugs_to_mapit_ids)
    end
  end

  describe 'Mapit ids to Pombola slugs' do
    let(:pombola_to_mapit) do
      new_tempfile(
        'gwagwaladakuje,949,FED
federal-capital-territory,16,STA
abakalikiizzi,1091,FED
ebonyi,12,STA'
      )
    end
    let(:mappings) do
      Mapit::Mappings.new(pombola_slugs_to_mapit_ids_filename: pombola_to_mapit)
    end

    it 'can map all mapit ids to their Pombola slug' do
      mappings.mapit_ids_to_pombola_slugs.count.must_equal(4)
    end

    it 'uses the mapit id as key and the slug as value' do
      mappings.mapit_ids_to_pombola_slugs['12'].must_equal('ebonyi')
    end

    it 'returns nil if mapit id does not exist' do
      assert_nil(mappings.mapit_ids_to_pombola_slugs['0'])
    end

    it 'can map all Pombola slugs to their mapit ids' do
      mappings.pombola_slugs_to_mapit_ids.count.must_equal(4)
    end

    it 'uses the Pombola slug as key and the mapit id as value' do
      mappings.pombola_slugs_to_mapit_ids['ebonyi'].must_equal('12')
    end

    it 'returns nil if Pombola slug does not exist' do
      assert_nil(mappings.pombola_slugs_to_mapit_ids['i-dont-exist'])
    end
  end

  describe 'EP to mapit area mappings' do
    let(:mapit_to_ep_fed) do
      new_tempfile(
        '1139,"area/adavi/okehi,_kogi_state"
1203,"area/ado-odo/ota,_ogun_state"'
      )
    end
    let(:mapit_to_ep_sen) do
      new_tempfile(
        '832,"area/borno_south,_borno_state"
836,"area/delta_central,_delta_state"'
      )
    end
    let(:mappings) do
      Mapit::Mappings.new(
        mapit_to_ep_areas_filenames: [mapit_to_ep_fed, mapit_to_ep_sen]
      )
    end

    it 'can map all ep areas to their mapit area' do
      mappings.ep_to_mapit_ids.count.must_equal(4)
    end

    it 'returns EP to mapit as a hash' do
      mappings.ep_to_mapit_ids['area/adavi/okehi,_kogi_state'].must_equal('1139')
      mappings.ep_to_mapit_ids['area/borno_south,_borno_state'].must_equal('832')
    end

    it 'returns nil if EP id does not exist' do
      assert_nil(mappings.ep_to_mapit_ids['foo'])
    end
  end
end
