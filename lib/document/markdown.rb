# frozen_string_literal: true
require 'rdiscount'

module Document
  class Markdown
    # Regex from Jekyll
    # https://github.com/jekyll/jekyll/blob/master/lib/jekyll/document.rb#L10
    YAML_FRONT_MATTER_REGEXP = %r!\A(---\s*\n.*?\n?)^((---|\.\.\.)\s*$\n?)!m

    def initialize(filename:)
      @filename = filename
    end

    def raw
      contents.sub(YAML_FRONT_MATTER_REGEXP, '')
    end

    def as_html
      parser.to_html
    end

    private

    attr_reader :filename

    def file
      @file_memo ||= File.open(filename, 'r')
    end

    def parser
      @parser ||= RDiscount.new(raw)
    end

    def contents
      @contents ||= file.read
      file.close
      @contents
    end
  end
end
