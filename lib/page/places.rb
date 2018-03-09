# frozen_string_literal: true

module Page
  class Places
    attr_reader :title, :places

    def initialize(title:, places:, people_by_legislature:)
      @title = title
      @places = places
      @people_by_legislature = people_by_legislature
    end

    def legislature_name
      people_by_legislature.legislature_name
    end

    def current_term_start_year
      people_by_legislature.current_term_start_date.year
    end

    private

    attr_reader :people_by_legislature
  end
end
