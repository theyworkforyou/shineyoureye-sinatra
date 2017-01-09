# frozen_string_literal: true
require_relative 'breadcrumb'

module Breadcrumbs
  class RouteToDisplayTextWrapper
    def initialize(routes:)
      @routes = routes
    end

    def breadcrumbify
      routes.map { |route, display_text| create_breadcrumb(route, display_text) }
    end

    private

    attr_reader :routes

    def create_breadcrumb(route, display_text)
      Breadcrumb.new(route, display_text)
    end
  end
end
