# frozen_string_literal: true
require_relative 'place'

module Mapit
  class Wrapper
    def initialize(mapit_url:, mapit_mappings:, baseurl:)
      @mapit_url = mapit_url
      @mapit_mappings = mapit_mappings
      @baseurl = baseurl
      cache_mapit_data(['FED', 'STA'])
    end

    def cache_mapit_data(mapit_area_types)
      @type_to_places = mapit_area_types.map { |t| [t, areas(t)] }.to_h
      @id_to_place = @type_to_places.values.flatten.map { |a| [a.id, a] }.to_h
      # Set parent-child relationships:
      fed_to_sta_mapping.each do |child, parent|
        child, parent = Integer(child), Integer(parent)
        @id_to_place[child].parent = @id_to_place[parent]
      end
    end

    def states
      @type_to_places['STA']
    end

    def federal_constituencies
      @type_to_places['FED']
    end

    def senatorial_districts
      @districts ||= add_parent_data(areas('SEN')).map { |area| create_place(area) }
    end

    def area_from_ep_id(id)
      mapit_id = ep_to_mapit_ids[id].to_i
      all_areas.find { |area| area.id == mapit_id }
    end

    private

    attr_reader :mapit_url, :mapit_mappings, :baseurl

    def all_areas
      states + federal_constituencies + senatorial_districts
    end

    def areas(area_type)
      areas_data(area_type).map { |a| create_place(a) }
    end

    def areas_data(area_type)
      uri = URI(mapit_url + area_type)
      JSON.parse(Net::HTTP.get(uri)).values
    end

    def add_parent_data(child_areas)
      child_areas.map do |area|
        parent = {
          'parent_id' => parent_id(area),
          'parent_name' => parent_name(area)
        }
        area.merge(parent)
      end
    end

    def parent_id(area)
      area['parent_area'] || fed_to_sta_mapping[area['id'].to_s].to_i
    end

    def parent_name(area)
      states.find { |state| state.id == parent_id(area) }.name
    end

    def mapit_ids_to_pombola_slugs
      mapit_mappings.mapit_ids_to_pombola_slugs
    end

    def fed_to_sta_mapping
      mapit_mappings.fed_to_sta_mapping
    end

    def ep_to_mapit_ids
      mapit_mappings.ep_to_mapit_ids
    end

    def create_place(area)
      Mapit::Place.new(
        place: area,
        pombola_slug: mapit_ids_to_pombola_slugs[area['id'].to_s],
        baseurl: baseurl
      )
    end
  end
end
