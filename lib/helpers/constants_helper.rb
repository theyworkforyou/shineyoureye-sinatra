module ConstantsHelper
  def content_dir
    settings.content_dir
  end

  def info_dir
    "#{content_dir}/info"
  end

  def posts_dir
    "#{content_dir}/posts"
  end
end

helpers ConstantsHelper
