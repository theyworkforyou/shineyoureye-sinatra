# frozen_string_literal: true

module PersonProxyImages
  def thumbnail_image_url
    proxy_image_variant(:thumbnail)
  end

  def medium_image_url
    proxy_image_variant(:medium)
  end

  def original_image_url
    proxy_image_variant(:original)
  end

  private

  ALLOWED_IMAGE_SIZES = {
    thumbnail: '100x100',
    medium: '250x250',
    original: 'original'
  }.freeze

  def proxy_image_variant(size)
    return if image.nil?
    raise_unless_image_size_available(size)
    proxy_image_base_url + ALLOWED_IMAGE_SIZES[size] + '.jpeg'
  end

  def raise_unless_image_size_available(size)
    error_message = "Size #{size} is not known to be available"
    raise error_message unless ALLOWED_IMAGE_SIZES.key?(size)
  end
end
