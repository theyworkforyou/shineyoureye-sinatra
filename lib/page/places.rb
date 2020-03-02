# frozen_string_literal: true

module Page
  class Places
    attr_reader :title, :places

    def initialize(title:, places:, people_by_legislature:)
      @title = title
      @places = places
      @people_by_legislature = people_by_legislature
      @states = %w[Lagos Kano Ekiti Ondo Kwara Kogi Enugu Anambra].sort
    end

    def place_sort_by_parent_place
      places.find_all
            .sort_by(&:name)
            .sort_by { |p| p.parent.nil? ? '' : p.parent.name }
    end

    def place_and_people_grouped_by_state
      people_by_legislature.find_people_grouped_by_state
    end

    def legislature_name
      people_by_legislature.legislature_name
    end

    def filter_places_with_all_legislature
      places.find_all { |p| place_and_people_grouped_by_state.include? p.name }
    end

    def filter_places_with_updated_profile
      filter_places_with_all_legislature.select { |e| states.include?(e.name) }
    end

    def filter_places_with_incomplete_profile
      filter_places_with_all_legislature.reject { |e| states.include?(e.name) }
    end

    def current_term_start_year
      people_by_legislature.current_term_start_date.year
    end

    private

    attr_reader :people_by_legislature, :states
  end
end
