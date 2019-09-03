# frozen_string_literal: true

require 'yaml'

module Document
  class FrontmatterParser
    def initialize(filecontents:)
      @filecontents = filecontents
    end

    def title
      fetch('title')
    end

    def slug
      fetch('slug')
    end

    def published?
      fetch('published', true)
    end

    def featured?
      fetch('featured', false)
    end

    def event_date
      fetch('eventdate')
    end

    private

    attr_reader :filecontents

    def parse
      YAML.safe_load(filecontents) || {}
    end

    def fetch(key, default_value = '')
      parse.fetch(key, default_value)
    end
  end
end
