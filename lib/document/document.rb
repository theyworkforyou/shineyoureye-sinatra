# frozen_string_literal: true
module Document
  class Document
    def initialize(filename:, baseurl:)
      @filename = filename
      @baseurl = baseurl
      @date = nil
      if /^(\d{4}-\d{2}-\d{2})/ =~ File.basename(filename)
        @date = Date.iso8601($1)
      end
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

    attr_reader :date

    private

    attr_reader :filename, :baseurl

    def filecontents
      @contents ||= File.open(filename, 'r') { |f| f.read }
    end

    def frontmatter
      @frontmatter ||= Frontmatter.new(filecontents: filecontents)
    end

    def markdown
      @markdown ||= Markdown.new(filecontents: filecontents)
    end
  end
end
