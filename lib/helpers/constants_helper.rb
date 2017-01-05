module ConstantsHelper
  def content_dir
    settings.content_dir
  end

  def posts_dir
    "#{content_dir}/posts"
  end
end

helpers ConstantsHelper
