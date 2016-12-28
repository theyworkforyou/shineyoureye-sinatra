# frozen_string_literal: true
require 'yaml'

module Document
  class Frontmatter
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

    private

    attr_reader :filecontents

    def parse
      YAML::load(filecontents) || {}
    end

    def fetch(key, default_value = '')
      parse.fetch(key, default_value)
    end
  end
end
