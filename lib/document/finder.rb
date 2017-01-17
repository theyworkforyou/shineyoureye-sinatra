# frozen_string_literal: true
require_relative 'markdown_with_frontmatter'

module Document
  class Finder
    def initialize(pattern:, baseurl:)
      @pattern = pattern
      @baseurl = baseurl
    end

    def find_single
      raise "Multiple posts matched '#{pattern}'" if multiple?
      raise Sinatra::NotFound if none?
      find_all.first
    end

    def find_all
      filenames.map { |filename| create_document(filename) }
    end

    private

    attr_reader :pattern, :baseurl

    def multiple?
      filenames.size > 1
    end

    def none?
      filenames.empty?
    end

    def filenames
      @filenames ||= Dir.glob(pattern)
    end

    def create_document(filename)
      Document::MarkdownWithFrontmatter.new(filename: filename, baseurl: baseurl)
    end
  end
end
