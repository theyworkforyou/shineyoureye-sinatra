# frozen_string_literal: true

module Page
  class Posts
    attr_reader :title

    def initialize(posts:, title:)
      @posts = posts
      @title = title
    end

    def sorted_posts
      posts.sort_by(&:date).reverse
    end

    def format_date(date)
      date.strftime('%B %-d, %Y')
    end

    def post_excerpt(body)
      HTML_Truncator.truncate(body, 80)
    end

    private

    attr_reader :posts
  end
end 
