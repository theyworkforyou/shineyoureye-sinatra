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

    def people_by_state
      # TODO: Handle people with missing areas better?
      # @people_by_state = people.group_by {|person| person.area.state.name}.sort.to_h
      @people_by_state = people.reject { |p| p.area.nil? }
                               .group_by { |person| person.area.state.name }
                               .sort.to_h
    end

    private

    attr_reader :people_by_legislature
  end
end
