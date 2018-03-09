# frozen_string_literal: true

module Page
  class Basic
    attr_reader :title

    def initialize(title:)
      @title = title
    end
  end
end
