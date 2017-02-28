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
  }

  def proxy_image_variant(size)
    raise_unless_image_size_available(size)
    proxy_image_url + ALLOWED_IMAGE_SIZES[size] + '.jpeg'
  end

  def raise_unless_image_size_available(size)
    unless ALLOWED_IMAGE_SIZES.has_key?(size)
      raise "Size #{size} is not known to be available"
    end
  end
end
