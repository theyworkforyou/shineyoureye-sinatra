# frozen_string_literal: true

require_relative 'exceptions'
require_relative 'markdown_with_frontmatter'
require_relative 'empty_document'

module Document
  class Finder
    def initialize(pattern:, baseurl:)
      @pattern = pattern
      @baseurl = baseurl
    end

    def find_single
      raise_error_if_multiple_files_found
      raise_error_if_no_files_found
      find_all.first
    end

    def find_or_empty
      none? ? create_empty_document : find_all.first
    end

    def find_all
      filenames.map { |filename| create_document(filename) }
    end

    def find_featured
      find_all.select(&:featured?)
    end

    def multiple?
      filenames.size > 1
    end

    def none?
      filenames.empty?
    end

    private

    attr_reader :pattern, :baseurl

    def raise_error_if_multiple_files_found
      raise "Multiple posts matched '#{pattern}'" if multiple?
    end

    def raise_error_if_no_files_found
      message = "No documents matched '#{pattern}'"
      raise Document::NoFilesFoundError, message if none?
    end

    def filenames
      @filenames ||= Dir.glob(pattern).sort
    end

    def create_document(filename)
      Document::MarkdownWithFrontmatter.new(filename: filename, baseurl: baseurl)
    end

    def create_empty_document
      Document::EmptyDocument.new
    end
  end
end
