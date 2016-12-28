# frozen_string_literal: true
require 'yaml'

module Document
  class Frontmatter
    def initialize(filename:)
      @filename = filename
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

    attr_reader :filename

    def parse
      @hash_memo ||= YAML::load_file(filename) || {}
    end

    def fetch(key, default_value = '')
      parse.fetch(key, default_value)
    end
  end
end
