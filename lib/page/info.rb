# frozen_string_literal: true

module Page
  class Info
    def initialize(static_page:)
      @static_page = static_page
    end

    def title
      static_page.title
    end

    def body
      static_page.body
    end

    private

    attr_reader :static_page
  end
end
