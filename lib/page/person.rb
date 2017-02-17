# frozen_string_literal: true
module Page
  class Person
    attr_reader :person, :position

    def initialize(person:, position:)
      @person = person
      @position = position
    end

    def title
      person.name
    end

    def share_name
      person.name
    end

    def summary
      ''
    end

    def executive_positions
      [] # sort by start date reverse
    end

    def job_history
      [] # sort by start date reverse
    end

    def education
      [] # sort by start date reverse
    end
  end
end
