# frozen_string_literal: true
module Page
  class Jinja2
    # This page is just to provide an empty page with a Jinja2
    # {% include %} tag, such that we might reuse it in the
    # polling unit lookup frontend to get the same HTML and CSS.
    attr_reader :title

    def initialize(title:)
      @title = title
    end
  end
end
