# frozen_string_literal: true
module Page
  class Place
    attr_reader :place

    def initialize(place:, people_by_legislature:, geometry:)
      @place = place
      @people_by_legislature = people_by_legislature
      @geometry = geometry
    end

    def title
      place.name
    end

    def share_name
      place.name
    end

    def people
      people_by_legislature.find_all_by_mapit_area(place.id)
    end

    def legislature_name
      name = people_by_legislature.legislature_name
      name ? "(#{name})" : ''
    end

    def geojson
      geometry.geojson
    end

    def center
      [geometry.center.latitude, geometry.center.longitude]
    end

    private

    attr_reader :people_by_legislature, :geometry
  end
end
