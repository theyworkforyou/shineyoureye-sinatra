# frozen_string_literal: true
module Page
  class Person
    attr_reader :person, :position

    def initialize(person:, position:, summary_doc:)
      @person = person
      @position = position
      @summary_doc = summary_doc
    end

    def title
      person.name
    end

    def share_name
      person.name
    end

    def email
      person.email
    end

    def wikipedia_url
      person.wikipedia_url
    end

    def summary
      summary_doc.body
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

    private

    attr_reader :summary_doc
  end
end
