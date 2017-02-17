# frozen_string_literal: true
require_relative 'place'

module Mapit
  class Wrapper
    def initialize(mapit_url:, mapit_mappings:, baseurl:)
      @mapit_url = mapit_url
      @mapit_mappings = mapit_mappings
      @baseurl = baseurl
    end

    def states
      @states ||= areas('STA').map { |area| create_place(area) }
    end

    def federal_constituencies
      @constituencies ||= add_parent_data(areas('FED')).map { |area| create_place(area) }
    end

    def senatorial_districts
      @districts ||= add_parent_data(areas('SEN')).map { |area| create_place(area) }
    end

    def area_from_pombola_slug(slug)
      find_single(pombola_slugs_to_mapit_ids[slug].to_i)
    end

    def area_from_ep_id(id)
      find_single(ep_to_mapit_ids[id].to_i)
    end

    private

    attr_reader :mapit_url, :mapit_mappings, :baseurl

    def all_areas
      states + federal_constituencies + senatorial_districts
    end

    def areas(area_type)
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

    def find_single(id)
      all_areas.find { |area| area.id == id }
    end

    def pombola_slugs_to_mapit_ids
      mapit_mappings.pombola_slugs_to_mapit_ids
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
        mapit_ids_to_pombola_slugs: mapit_ids_to_pombola_slugs,
        baseurl: baseurl
      )
    end
  end
end
