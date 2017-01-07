# frozen_string_literal: true
require 'uri'
require_relative 'breadcrumb'

module Breadcrumbs
  class Builder
    def initialize(current_url:, routes_wrapper:)
      @current_url = current_url
      @routes_wrapper = routes_wrapper
    end

    def breadcrumbs
      breadcrumb_routes_excluding_current_page.map do |route|
        find_breadcrumb_by_route(route)
      end.compact
    end

    private

    attr_reader :current_url, :routes_wrapper

    def breadcrumb_routes_excluding_current_page
      breadcrumb_routes[0..-2]
    end

    def breadcrumb_routes
      memo = ''
      paths.map { |path| memo = "#{memo}#{path}/" }
    end

    def paths
      URI(current_url).path.split('/')
    end

    def find_breadcrumb_by_route(route)
      routes_wrapper.find_breadcrumb_by_route(route)
    end
  end
end
