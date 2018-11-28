# frozen_string_literal: true

require 'rdiscount'

module Document
  class MarkdownParser
    # Regex from Jekyll
    # https://github.com/jekyll/jekyll/blob/fac041933c3e328ff73dc91faeaeb08182ae3c74/
    #     lib/jekyll/document.rb#L10
    YAML_FRONT_MATTER_REGEXP = /\A(---\s*\n.*?\n?)^((---|\.\.\.)\s*$\n?)/m.freeze

    def initialize(filecontents:)
      @filecontents = filecontents
    end

    def raw
      filecontents.sub(YAML_FRONT_MATTER_REGEXP, '')
    end

    def as_html
      parser.to_html.gsub(/{{site.baseurl}}/, '')
    end

    private

    attr_reader :filecontents

    def parser
      @parser ||= RDiscount.new(raw)
    end
  end
end
