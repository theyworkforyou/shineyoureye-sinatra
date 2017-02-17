module LayoutHelper
  def meta_title(page)
    is_homepage? ? site_title : title(page)
  end

  def site_title
    'Shine your eye'
  end

  def is_homepage?
    request.env['PATH_INFO'].match(/^\/?$/)
  end

  def add_active_class(path)
    is_current_page?(path) ? active_class : ''
  end

  private

  def title(page)
    "#{page.title} :: #{site_title}"
  end

  def is_current_page?(path)
    request.env['PATH_INFO'] == path
  end

  def active_class
    ' class="active"'
  end
end

helpers LayoutHelper
