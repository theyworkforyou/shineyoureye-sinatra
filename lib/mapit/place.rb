# frozen_string_literal: true
module Mapit
  class Place
    attr_reader :parent

    def initialize(place:, parent:, pombola_slug:, baseurl:)
      @place = place
      @parent = parent
      @pombola_slug = pombola_slug
      @baseurl = baseurl
    end

    def id
      place['id']
    end

    def name
      place['name']
    end

    def url
      baseurl + pombola_slug + '/'
    end

    private

    attr_reader :place, :pombola_slug, :baseurl
  end
end
