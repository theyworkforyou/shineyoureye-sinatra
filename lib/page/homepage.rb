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
      future_events.sort_by { |d| d.event_date }.first(3)
    end

    def no_events?
      featured_events.empty?
    end

    def format_date(date)
      date.strftime("%B %-d, %Y")
    end

    private

    attr_reader :posts, :events

    def future_events
      events.select do |d|
        raise_no_event_date_error(d)
        d.event_date >= Date.today
      end
    end

    def raise_no_event_date_error(d)
      raise "No event date for #{d.title}" unless d.event_date
    end
  end
end
