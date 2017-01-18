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

  private

  def title(page)
    "#{page.title} :: #{site_title}"
  end
end

helpers LayoutHelper
