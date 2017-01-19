# frozen_string_literal: true
module BreadcrumbsHelper
  ROUTE_TO_DISPLAY_TEXT = {
    '/' => 'Home',
    '/blog/' => 'Blog',
    '/info/events' => 'Events',
  }
end

helpers BreadcrumbsHelper
