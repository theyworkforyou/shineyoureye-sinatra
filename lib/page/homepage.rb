# frozen_string_literal: true
module Page
  class Homepage
    def initialize(posts:, events:)
      @posts = posts
      @events = events
    end

    def featured_posts
      posts.sort_by(&:date).reverse.first(3)
    end

    def featured_events
      future_events.sort_by(&:event_date).first(3)
    end

    def no_events?
      featured_events.empty?
    end

    def format_date(date)
      date.strftime('%B %-d, %Y')
    end

    private

    attr_reader :posts, :events

    def future_events
      events.select do |event|
        raise_no_event_date_error(event)
        event.event_date >= Date.today
      end
    end

    def raise_no_event_date_error(event)
      raise "No event date for #{event.title}" unless event.event_date
    end
  end
end
