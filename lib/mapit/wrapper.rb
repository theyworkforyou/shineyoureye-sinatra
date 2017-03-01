# frozen_string_literal: true
require_relative 'place'

module Mapit
  class Wrapper
    def initialize(mapit_url:, mapit_mappings:, baseurl:, parent_area_type:, child_area_types:)
      @mapit_url = mapit_url
      @mapit_mappings = mapit_mappings
      @baseurl = baseurl
      @parent_area_type = parent_area_type
      @child_area_types = child_area_types
      @type_to_places = {}
    end

    def area_types
      [parent_area_type] + child_area_types
    end

    def all_areas
      @all_areas ||= area_types.flat_map do |area_type|
        places_of_type(area_type)
      end
    end

    def places_of_type(area_type)
      @type_to_places[area_type] ||= add_parent_data(area_type).map do
        |area| create_place(area)
      end
    end

    def area_from_pombola_slug(slug)
      find_single(pombola_slugs_to_mapit_ids[slug].to_i)
    end

    def area_from_ep_id(id)
      find_single(ep_to_mapit_ids[id].to_i)
    end

    private

    attr_reader :mapit_url, :mapit_mappings, :baseurl, :parent_area_type, :child_area_types

    def areas(area_type)
      uri = URI(mapit_url + area_type)
      JSON.parse(Net::HTTP.get(uri)).values
    end

    def add_parent_data(area_type)
      return areas(area_type) if area_type == parent_area_type
      areas(area_type).map do |area|
        parent = {
          'parent_id' => parent_id(area),
          'parent_name' => parent_name(area)
        }
        area.merge(parent)
      end
    end

    def parent_id(area)
      area['parent_area'] || child_to_parent[area['id'].to_s].to_i
    end

    def parent_name(area)
      places_of_type(parent_area_type).find { |state| state.id == parent_id(area) }.name
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

    def child_to_parent
      mapit_mappings.child_to_parent
    end

    def ep_to_mapit_ids
      mapit_mappings.ep_to_mapit_ids
    end

    def create_place(area)
      Mapit::Place.new(
        mapit_area_data: area,
        mapit_ids_to_pombola_slugs: mapit_ids_to_pombola_slugs,
        baseurl: baseurl
      )
    end
  end
end
