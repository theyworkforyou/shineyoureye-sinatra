# frozen_string_literal: true

require 'test_helper'
require_relative '../../lib/mapit/wrapper'

describe 'Mappit::Wrapper' do
  let(:mapit) do
    Mapit::Wrapper.new(
      mapit_mappings: FakeMappings.new,
      baseurl: '/baseurl/',
      area_types: %w(FED SEN STA),
      data_directory: 'mapit'
    )
  end

  describe 'when getting the states' do
    it 'gets a list of all the states' do
      mapit.places_of_type('STA').count.must_equal(37)
    end

    # The last state in MapIt's list is Zamfara, with ID 38:
    it 'has states with an id and it is an integer' do
      mapit.places_of_type('STA').last.id.must_equal(38)
    end

    it 'has states with a name' do
      mapit.places_of_type('STA').last.name.must_equal('Zamfara')
    end

    it 'has states that use the baseurl in their url' do
      mapit.places_of_type('STA').first.url.must_equal('/baseurl/abia/')
    end

    it 'does not have parent data for the states' do
      assert_nil(mapit.places_of_type('STA').first.parent)
    end
  end

  describe 'when getting the federal constituencies' do
    it 'gets a list of all the federal constituencies' do
      mapit.places_of_type('FED').count.must_equal(360)
    end

    it 'has federal constituencies with a name' do
      mapit.places_of_type('FED').first.name.must_equal('Abaji/Gwagwalada/Kwali/Kuje')
    end

    it 'has federal constituencies that use the baseurl' do
      mapit.places_of_type('FED').first.url.must_equal('/baseurl/gwagwaladakuje/')
    end

    it 'has federal constituencies with a parent name' do
      mapit.places_of_type('FED').first.parent.name.must_equal('Federal Capital Territory')
    end

    it 'has federal constituencies with a parent url' do
      mapit.places_of_type('FED').first.parent.url.must_equal('/baseurl/federal-capital-territory/')
    end
  end

  describe 'when getting the senatorial districts' do
    it 'gets a list of all the senatorial districts' do
      mapit.places_of_type('SEN').count.must_equal(109)
    end

    it 'has senatorial districts with a name' do
      mapit.places_of_type('SEN').first.name.must_equal('ABIA CENTRAL')
    end

    it 'has senatorial districts that use the baseurl' do
      mapit.places_of_type('SEN').first.url.must_equal('/baseurl/abia-central/')
    end

    it 'has senatorial districts with a parent name' do
      mapit.places_of_type('SEN').first.parent.name.must_equal('Abia')
    end
  end

  describe 'when getting a single area from an EP id' do
    it 'finds a federal constituency' do
      ep_id = 'area/kuje/abaji/gwagwalada/kwali,_federal_capital_territory_state'
      mapit.area_from_ep_id(ep_id).name.must_equal('Abaji/Gwagwalada/Kwali/Kuje')
    end

    it 'finds a senatorial district' do
      ep_id = 'area/abia-central,_abia_state'
      mapit.area_from_ep_id(ep_id).name.must_equal('ABIA CENTRAL')
    end
  end

  describe 'when getting a single area from a pombola slug' do
    it 'finds a state' do
      pombola_slug = 'abia'
      mapit.area_from_pombola_slug(pombola_slug).name.must_equal('Abia')
    end

    it 'finds a federal constituency' do
      pombola_slug = 'gwagwaladakuje'
      mapit.area_from_pombola_slug(pombola_slug).name.must_equal('Abaji/Gwagwalada/Kwali/Kuje')
    end

    it 'finds a senatorial district' do
      pombola_slug = 'abia-central'
      mapit.area_from_pombola_slug(pombola_slug).name.must_equal('ABIA CENTRAL')
    end
  end

  describe 'when getting an area from a Mapit state name' do
    it 'finds a state' do
      mapit.area_from_mapit_name('Abia').id.must_equal(2)
    end

    it 'finds a federal constituency' do
      mapit.area_from_mapit_name('Federal Capital Territory').id.must_equal(16)
    end

    it 'finds a senatorial district' do
      mapit.area_from_mapit_name('ABIA CENTRAL').id.must_equal(809)
    end

    it 'returns nil if no area was found' do
      assert_nil(mapit.area_from_mapit_name('I-dont-exist'))
    end
  end

  class FakeMappings
    def child_to_parent
      { '949' => '16', '1091' => '12', '963' => '9', '809' => '2' }
    end

    def mapit_ids_to_pombola_slugs
      { '949' => 'gwagwaladakuje', '16' => 'federal-capital-territory',
        '809' => 'abia-central', '2' => 'abia' }
    end

    def pombola_slugs_to_mapit_ids
      { 'gwagwaladakuje' => '949', 'abia-central' => '809', 'abia' => '2' }
    end

    def ep_to_mapit_ids
      {
        'area/kuje/abaji/gwagwalada/kwali,_federal_capital_territory_state' => '949',
        'area/abia-central,_abia_state' => '809'
      }
    end
  end
end
