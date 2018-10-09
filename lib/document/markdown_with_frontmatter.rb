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
      match_data = DATE_PATTERN.match(basename)
      Date.iso8601(match_data[:date]) if match_data
    end

    def title
      frontmatter.title
    end

    def url
      baseurl + slug
    end

    def published?
      frontmatter.published?
    end

    def featured?
      frontmatter.featured?
    end

    def event_date
      return nil if frontmatter.event_date.empty?

      Date.parse(frontmatter.event_date)
    end

    def body
      markdown.as_html
    end

    def slug
      rawname
    end

    private

    DATE_PATTERN = /^(?<date>\d{4}-\d{2}-\d{2})/
    attr_reader :filename, :baseurl

    def basename
      File.basename(filename)
    end

    def extname
      File.extname(filename)
    end

    def rawname
      basename.gsub(/#{DATE_PATTERN}-/, '').gsub(extname, '')
    end

    def filecontents
      @filecontents ||= File.open(filename, 'r', &:read)
    end

    def frontmatter
      @frontmatter ||= FrontmatterParser.new(filecontents: filecontents)
    end

    def markdown
      @markdown ||= MarkdownParser.new(filecontents: filecontents)
    end
  end
end
