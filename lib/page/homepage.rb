# frozen_string_literal: true

module Page
  class Homepage
    RANDOM_PERSON_COUNT_PER_TYPE = 10

    def initialize(posts:, events:, governors:, senators:, representatives:, honorables:)
      @posts = posts
      @events = events
      @governors = governors
      @senators = senators
      @representatives = representatives
      @honorables = honorables
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

    def government_representative_types
      [
        build_representative_type(governors, 'Governors', '/position/executive-governor/'),
        build_representative_type(senators, 'Senators', '/position/senator/'),
        build_representative_type(representatives, 'Representatives', '/position/representative/'),
        build_representative_type(honorables, 'Honorables', '/position/state-legislators/')
      ]
    end

    private

    attr_reader :posts, :events, :governors, :senators, :representatives, :honorables

    def future_events
      events.select do |event|
        raise_error_if_no_event_date(event)
        event.event_date >= Date.today
      end
    end

    def raise_error_if_no_event_date(event)
      raise "No event date for #{event.title}" unless event.event_date
    end

    def sample_collection(collection, count = 1)
      collection.find_all.reject { |item| item.image.nil? }.sample(count)
    end

    def build_representative_type(collection, link_text, link_url)
      OpenStruct.new(
        people: sample_collection(collection, RANDOM_PERSON_COUNT_PER_TYPE),
        link_text: link_text,
        link_url: link_url
      )
    end
  end
end
