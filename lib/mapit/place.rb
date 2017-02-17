# frozen_string_literal: true
module Mapit
  class Place
    def initialize(place:, mapit_ids_to_pombola_slugs:, baseurl:)
      @place = place
      @mapit_ids_to_pombola_slugs = mapit_ids_to_pombola_slugs
      @baseurl = baseurl
    end

    def id
      place['id']
    end

    def name
      place['name']
    end

    def type_name
      place['type_name']
    end

    def parent_name
      place['parent_name']
    end

    def url
      build_url(place['id']) if place['id']
    end

    def parent_url
      build_url(place['parent_id']) if place['parent_id']
    end

    private

    attr_reader :place, :mapit_ids_to_pombola_slugs, :baseurl

    def build_url(id)
      "#{baseurl}#{pombola_slug(id)}/"
    end

    def pombola_slug(id)
      mapit_ids_to_pombola_slugs[id.to_s]
    end
  end
end
