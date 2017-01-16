# frozen_string_literal: true
require_relative '../document/markdown_with_frontmatter'

module Page
  class Info
    def initialize(baseurl:, directory:, slug:)
      @baseurl = baseurl
      @directory = directory
      @slug = slug
    end

    def title
      static_page.title
    end

    def body
      static_page.body
    end

    def none?
      found.empty?
    end

    private

    attr_reader :baseurl, :directory, :slug

    def found
      @found ||= Dir.glob(pattern)
    end

    def pattern
      "#{directory}/#{slug}.md"
    end

    def static_page
      Document::MarkdownWithFrontmatter.new(filename: found.first, baseurl: baseurl)
    end
  end
end
