# frozen_string_literal: true
require_relative '../functions/breadcrumbs'

# This Sinatra helper provides data for rendering "breadcrumbs" on a
# page, based on the 'breadcrumbs' configuration setting in app.rb.
module BreadcrumbsHelper
  def breadcrumbs_data
    make_breadcrumbs(request.env['PATH_INFO'], settings.breadcrumbs)
  end
end

helpers BreadcrumbsHelper
