# frozen_string_literal: true
module Document
  class Document
    def initialize(filename:, baseurl:)
      @filename = filename
      @baseurl = baseurl
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

    def frontmatter
      @frontmatter ||= Frontmatter.new(filename: filename)
    end

    def markdown
      @markdown ||= Markdown.new(filename: filename)
    end
  end
end
