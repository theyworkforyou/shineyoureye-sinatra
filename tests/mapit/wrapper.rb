# frozen_string_literal: true

require 'test_helper'
require_relative '../../lib/mapit/wrapper'

describe 'Mappit::Wrapper' do
  let(:mapit) do
    Mapit::Wrapper.new(
      mapit_mappings: FakeMappings.new,
      baseurl: '/baeurl/',
      area_types: %w[FED SEN STA],
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
      mapit.places_of_type('STA').first.url.wont_equal('/baseurl/abia/')
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
      mapit.places_of_type('FED').last.name.must_equal('Lagos Mainland')
    end

    # it 'has federal constituencies that use the baseurl' do
    #   mapit.places_of_type('FED').last.url.must_equal('/baseurl/lagos-mainland/')
    # end

    # it 'has federal constituencies with a parent name' do
    #   mapit.places_of_type('FED').last.parent.name.must_equal('Lagos')
    # end

    # it 'has federal constituencies with a parent url' do
    #   mapit.places_of_type('FED').last.parent.url.must_equal('/baseurl/lagos/')
    # end
  end

  describe 'when getting the senatorial districts' do
    it 'gets a list of all the senatorial districts' do
      mapit.places_of_type('SEN').count.must_equal(109)
    end

    it 'has senatorial districts with a name' do
      mapit.places_of_type('SEN').first.name.must_equal('Abia Central')
    end

    # it 'has senatorial districts that use the baseurl' do
    #   mapit.places_of_type('SEN').first.url.must_equal('/baseurl/abia-central/')
    # end

    # it 'has senatorial districts with a parent name' do
    #   mapit.places_of_type('SEN').first.parent.name.must_equal('Abia')
    # end
  end

  describe 'when getting a single area from an EP id' do
    it 'finds a federal constituency' do
      ep_id = 'area/Kuje/Abaji/Gwagwalada/Kwali,_federal_capital_territory_state'
      mapit.area_from_ep_id(ep_id).name.must_equal('Kuje/Abaji/Gwagwalada/Kwali')
    end

    it 'finds a senatorial district' do
      ep_id = 'area/abia-central,_abia_state'
      mapit.area_from_ep_id(ep_id).name.must_equal('Abia Central')
    end
  end

  describe 'when getting a single area from a pombola slug' do
    it 'finds a state' do
      pombola_slug = 'abia'
      mapit.area_from_pombola_slug(pombola_slug).name.must_equal('Abia')
    end

    it 'finds a federal constituency' do
      pombola_slug = 'kuje-abaji-gwagwalada-kwali'
      mapit.area_from_pombola_slug(pombola_slug).name.must_equal('Kuje/Abaji/Gwagwalada/Kwali')
    end

    it 'finds a senatorial district' do
      pombola_slug = 'abia-central'
      mapit.area_from_pombola_slug(pombola_slug).name.must_equal('Abia Central')
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
      mapit.area_from_mapit_name('Abia Central').id.must_equal(809)
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
      { '949' => 'kuje-abaji-gwagwalada-kwali', '16' => 'federal-capital-territory',
        '809' => 'abia-central', '2' => 'abia' }
    end

    def pombola_slugs_to_mapit_ids
      { 'kuje-abaji-gwagwalada-kwali' => '949', 'abia-central' => '809', 'abia' => '2' }
    end

    def ep_to_mapit_ids
      {
        'area/Kuje/Abaji/Gwagwalada/Kwali,_federal_capital_territory_state' => '949',
        'area/abia-central,_abia_state' => '809'
      }
    end
  end
end
