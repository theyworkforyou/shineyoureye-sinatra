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
      Date.iso8601($1) if DATE_PATTERN =~ basename
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

    def body
      markdown.as_html
    end

    private

    DATE_PATTERN = /^(\d{4}-\d{2}-\d{2})/
    attr_reader :filename, :baseurl

    def basename
      File.basename(filename)
    end

    def extname
      File.extname(filename)
    end

    def rawname
      basename.gsub(DATE_PATTERN, '').gsub(extname, '')[1..-1]
    end

    def slug
      slug = frontmatter.slug
      slug.empty? ? rawname : slug
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
