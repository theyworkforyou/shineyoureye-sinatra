# frozen_string_literal: true
module Mapit
  class Place
    def initialize(mapit_area_data:, mapit_ids_to_pombola_slugs:, baseurl:)
      @mapit_area_data = mapit_area_data
      @mapit_ids_to_pombola_slugs = mapit_ids_to_pombola_slugs
      @baseurl = baseurl
    end

    def id
      mapit_area_data['id']
    end

    def name
      mapit_area_data['name']
    end

    def type_name
      mapit_area_data['type_name']
    end

    def parent_name
      mapit_area_data['parent_name']
    end

    def url
      build_url(mapit_area_data['id']) if mapit_area_data['id']
    end

    def parent_url
      build_url(mapit_area_data['parent_id']) if mapit_area_data['parent_id']
    end

    def is_child_area?
      !mapit_area_data['parent_name'].nil?
    end

    private

    attr_reader :mapit_area_data, :mapit_ids_to_pombola_slugs, :baseurl

    def build_url(id)
      "#{baseurl}#{pombola_slug(id)}/"
    end

    def pombola_slug(id)
      mapit_ids_to_pombola_slugs[id.to_s]
    end
  end
end
