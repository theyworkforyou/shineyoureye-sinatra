module LayoutHelper
  def is_homepage?
    request.env['PATH_INFO'].match(/^\/?$/)
  end
end

helpers LayoutHelper
