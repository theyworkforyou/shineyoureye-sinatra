# frozen_string_literal: true
require 'net/http'
require_relative 'place'

module Mapit
  class Wrapper

    def initialize(mapit_url:, mapit_mappings:, baseurl:, area_types:)
      @mapit_url = mapit_url
      @baseurl = baseurl
      @area_types = area_types
      @mapit_mappings = mapit_mappings
      cache_mapit_data
      set_up_parent_child_relationships
    end

    def area_from_pombola_slug(slug)
      mapit_id = mapit_mappings.pombola_slugs_to_mapit_ids[slug]
      id_to_place[mapit_id]
    end

    def area_from_ep_id(id)
      id_to_place[mapit_mappings.ep_to_mapit_ids[id]]
    end

    def places_of_type(area_type)
      type_to_places[area_type]
    end

    private

    attr_reader :mapit_url,
                :mapit_mappings,
                :baseurl,
                :id_to_place,
                :area_types,
                :type_to_places

    def places(area_type)
      areas_data(area_type).map { |a| create_place(a) }
    end

    def areas_data(area_type)
      uri = URI(mapit_url + area_type)
      JSON.parse(Net::HTTP.get(uri)).values
    end

    def cache_mapit_data
      @type_to_places = area_types.map { |t| [t, places(t)] }.to_h
      @id_to_place = type_to_places.values.flatten.map { |a| [a.id.to_s, a] }.to_h
    end

    def set_up_parent_child_relationships
      # FIXME: this should also use MapIt's parent_area, if that's set.
      mapit_mappings.child_to_parent.each do |child, parent|
        if id_to_place.key?(child) && id_to_place.key?(parent)
          id_to_place[child].parent = id_to_place[parent]
        end
      end
    end

    def create_place(mapit_area_data)
      mapit_id = mapit_area_data['id'].to_s
      pombola_slug = mapit_mappings.mapit_ids_to_pombola_slugs[mapit_id]
      Mapit::Place.new(
        mapit_area_data: mapit_area_data,
        pombola_slug: pombola_slug,
        baseurl: baseurl
      )
    end
  end
end
