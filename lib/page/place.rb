# frozen_string_literal: true
module Page
  class Place
    attr_reader :place

    def initialize(place:, people_by_legislature:, people_path:)
      @place = place
      @people_by_legislature = people_by_legislature
      @people_path = people_path
    end

    def title
      place.name
    end

    def share_name
      place.name
    end

    def key_figure
      nil
    end

    def people
      people_by_legislature.find_all_by_mapit_area(place.id)
    end

    def legislature_name
      people_by_legislature.legislature_name
    end

    def current_term_start_date
      people_by_legislature.current_term_start_date.strftime("%B %-d, %Y")
    end

    def people_url
      (place.url + people_path).gsub('//', '/')
    end

    def places_url
      ''
    end

    private

    attr_reader :people_by_legislature, :people_path
  end
end
