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

    def people_by_party
      @people_by_party = people.reject { |p| p.party_name.nil? }
                               .group_by(&:party_name)
                               .sort
    end

    def party_of_people_and_size
      people_by_party.map { |party, p| [party, p.size] }
    end

    def people_by_position
      people_by_position = people.reject { |p| p.position.nil? }
                                 .sort_by { |p| p.position_order.to_i }
    end

    def sort_desc_party_of_people_and_size
      party_of_people_and_size.sort_by { |_p, value| value }.reverse.to_h
    end

    def people_current_term_start_date
      people_by_legislature.current_term_start_date
    end

    def people_current_term_end_date
      people_by_legislature.current_term_end_date
    end

    def people_legislature_term
      people_by_legislature.legislature_term
    end

    private

    attr_reader :people_by_legislature
  end
end
