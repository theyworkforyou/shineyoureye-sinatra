# frozen_string_literal: true

module Page
  class Homepage
    attr_reader :featured_people, :quote

    def initialize(posts:, events:, featured_people:, quote:)
      @posts = posts
      @events = events
      @featured_people = featured_people
      @quote = quote
    end

    def featured_posts
      posts.sort_by(&:date).reverse.first(2)
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
        raise_error_if_no_event_date(event)
        event.event_date >= Date.today
      end
    end

    def raise_error_if_no_event_date(event)
      raise "No event date for #{event.title}" unless event.event_date
    end
  end
end
