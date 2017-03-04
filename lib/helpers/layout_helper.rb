# frozen_string_literal: true

module LayoutHelper
  def meta_title(page)
    homepage? ? site_title : title(page)
  end

  def site_title
    'Shine your eye'
  end

  def homepage?
    request.env['PATH_INFO'].match(%r{^\/?$})
  end

  def add_active_class(path)
    current_page?(path) ? active_class : ''
  end

  private

  def title(page)
    "#{page.title} :: #{site_title}"
  end

  def current_page?(path)
    request.env['PATH_INFO'] == path
  end

  def active_class
    ' class="active"'
  end
end

helpers LayoutHelper
