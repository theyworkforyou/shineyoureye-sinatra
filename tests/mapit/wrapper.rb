# frozen_string_literal: true
require 'test_helper'
require_relative '../../lib/mapit/wrapper'

describe 'Mappit::Wrapper' do
  let(:mapit) { Mapit::Wrapper.new(
    mapit_url: mapit_url,
    mapit_mappings: FakeMappings.new,
    baseurl: '/baseurl/'
  ) }

  describe 'when getting the states' do
    it 'gets a list of all the states' do
      mapit.states.count.must_equal(3)
    end

    it 'has states with an id and it is an integer' do
      mapit.states.last.id.must_equal(2)
    end

    it 'has states with a name' do
      mapit.states.last.name.must_equal('Abia')
    end

    it 'has states that use the baseurl in their url' do
      mapit.states.first.url.must_equal('/baseurl/federal-capital-territory/')
    end

    it 'does not have parent data for the states' do
      assert_nil(mapit.states.first.parent_name)
      assert_nil(mapit.states.first.parent_url)
    end
  end

  describe 'when getting the federal constituencies' do
    it 'gets a list of all the federal constituencies' do
      mapit.federal_constituencies.count.must_equal(2)
    end

    it 'has federal constituencies with a name' do
      mapit.federal_constituencies.first.name.must_equal('Abaji/Gwagwalada/Kwali/Kuje')
    end

    it 'has federal constituencies that use the baseurl' do
      mapit.federal_constituencies.first.url.must_equal('/baseurl/gwagwaladakuje/')
    end

    it 'has federal constituencies with a parent name' do
      mapit.federal_constituencies.first.parent_name.must_equal('Federal Capital Territory')
    end

    it 'has federal constituencies with a parent url' do
      mapit.federal_constituencies.first.parent_url.must_equal('/baseurl/federal-capital-territory/')
    end
  end

  class FakeMappings
    def fed_to_sta_mapping
      { '949' => '16', '1091' => '12' }
    end

    def mapit_ids_to_pombola_slugs
      { '949' => 'gwagwaladakuje', '16' => 'federal-capital-territory' }
    end
  end
end
