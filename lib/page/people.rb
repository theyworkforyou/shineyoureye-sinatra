# frozen_string_literal: true

module Page
  class People
    attr_reader :title

    def initialize(title:, people_by_legislature:)
      @title = title
      @people_by_legislature = people_by_legislature
    end

    def people
      @people ||= people_by_legislature.find_all
    end

    private

    attr_reader :people_by_legislature
  end
end
