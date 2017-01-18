# frozen_string_literal: true
module Page
  class Homepage
    def initialize(posts:, events:)
      @posts = posts
      @events = events
    end

    def featured_posts
      posts.sort_by { |d| d.date }.reverse.first(3)
    end

    def featured_events
      events.sort_by { |d| d.date }.reverse.first(3)
    end

    def no_events?
      featured_events.empty?
    end

    def format_date(date)
      date.strftime("%B %-d, %Y")
    end

    private

    attr_reader :posts, :events
  end
end
