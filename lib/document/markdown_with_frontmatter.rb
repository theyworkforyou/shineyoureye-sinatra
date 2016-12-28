# frozen_string_literal: true
require_relative 'frontmatter_parser'
require_relative 'markdown_parser'

module Document
  class MarkdownWithFrontmatter
    def initialize(filename:, baseurl:)
      @filename = filename
      @baseurl = baseurl
    end

    def date
      Date.iso8601($1) if /^(\d{4}-\d{2}-\d{2})/ =~ basename
    end

    def title
      frontmatter.title
    end

    def url
      baseurl + frontmatter.slug
    end

    def published?
      frontmatter.published?
    end

    def body
      markdown.as_html
    end

    private

    attr_reader :filename, :baseurl

    def basename
      File.basename(filename)
    end

    def filecontents
      @contents ||= File.open(filename, 'r') { |f| f.read }
    end

    def frontmatter
      @frontmatter ||= FrontmatterParser.new(filecontents: filecontents)
    end

    def markdown
      @markdown ||= MarkdownParser.new(filecontents: filecontents)
    end
  end
end
