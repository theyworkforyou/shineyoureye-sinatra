# frozen_string_literal: true
require_relative '../document/markdown_with_frontmatter'

module Page
  class Post
    BASEURL = '/blog/'

    def initialize(directory:, slug:)
      @directory = directory
      @slug = slug
    end

    def title
      post.title
    end

    def date
      post.date.strftime("%B %-d, %Y")
    end

    def body
      post.body
    end

    private

    attr_reader :directory, :slug

    def found
      @found ||= Dir.glob(pattern)
    end

    def pattern
      date_glob = '[0-9][0-9][0-9][0-9]-[0-9][0-9]-[0-9][0-9]'
      "#{directory}/#{date_glob}-#{slug}.md"
    end

    def post
      Document::MarkdownWithFrontmatter.new(filename: found.first, baseurl: 'BASEURL')
    end
  end
end
