# frozen_string_literal: true
require_relative '../document/markdown_with_frontmatter'

module Page
  class Posts
    BASEURL = '/blog/'

    def initialize(directory:)
      @directory = directory
    end

    def sorted_posts
      posts.sort_by { |d| d.date }.reverse
    end

    def format_date(date)
      date.strftime("%B %-d, %Y")
    end

    private

    attr_reader :directory

    def posts
      filenames.map { |filename| create_post(filename) }
    end

    def filenames
      @filenames ||= Dir.glob(pattern)
    end

    def pattern
      date_glob = '[0-9][0-9][0-9][0-9]-[0-9][0-9]-[0-9][0-9]'
      "#{directory}/#{date_glob}-*.md"
    end

    def create_post(filename)
      Document::MarkdownWithFrontmatter.new(filename: filename, baseurl: BASEURL)
    end
  end
end
