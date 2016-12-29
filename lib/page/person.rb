# frozen_string_literal: true
module Page
  class Person
    attr_reader :person

    def initialize(person:)
      @person = person
    end

    def title
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
