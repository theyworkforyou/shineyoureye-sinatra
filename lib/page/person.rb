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

    def email
      person.email
    end

    def wikipedia_url
      person.wikipedia_url
    end

    def summary
      @summary ||= Document::MarkdownWithFrontmatter.new(
        filename: summary_markdown_filename, baseurl: nil
      ).body
    rescue Errno::ENOENT
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

    private

    def summary_markdown_filename
      leafname = "#{person.id}.md"
      File.join(
        File.dirname(__FILE__), '..', '..', 'prose', 'summaries', leafname
      )
    end
  end
end
