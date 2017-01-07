# frozen_string_literal: true
require_relative '../breadcrumbs/builder'
require_relative '../breadcrumbs/route_to_display_text_wrapper'

module BreadcrumbsHelper
  def breadcrumbs
    builder.breadcrumbs
  end

  def disable_breadcrumbs_for_current_page?
    is_homepage?
  end

  private

  ROUTE_TO_DISPLAY_TEXT = {
    '/' => 'Home',
    '/blog/' => 'Blog',
    '/info/events' => 'Events',
  }

  def builder
    Breadcrumbs::Builder.new(current_url: request.url, routes_wrapper: wrapper)
  end

  def wrapper
    Breadcrumbs::RouteToDisplayTextWrapper.new(routes: ROUTE_TO_DISPLAY_TEXT)
  end
end

helpers BreadcrumbsHelper
