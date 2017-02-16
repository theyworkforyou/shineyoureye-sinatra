# frozen_string_literal: true
module Mapit
  class Place
    attr_reader :parent

    def initialize(place:, pombola_slug:, baseurl:)
      @place = place
      @pombola_slug = pombola_slug
      @baseurl = baseurl
      @parent = nil
    end

    def id
      place['id']
    end

    def name
      place['name']
    end

    def parent=(parent_place)
      @parent = parent_place
    end

    def url
      "#{baseurl}#{pombola_slug}/"
    end

    private

    attr_reader :place, :pombola_slug, :baseurl

  end
end
