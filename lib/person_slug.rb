# frozen_string_literal: true

module PersonSlug
  def extra_slugs_filename
    File.join(__dir__, '..', 'data', 'extra-slugs.csv')
  end

  # rubocop:disable Style/ClassVars
  def extra_slugs
    # This won't change over the lifetime of the app, so memoize it to
    # a class variable to avoid frequent reloading. RuboCop objects to
    # this for reasons that I don't think apply here.
    @@extra_slugs ||= CSV.read(extra_slugs_filename,
                               headers: true,
                               header_converters: :symbol,
                               converters: nil).map do |row|
      [row[:uuid], row[:slug]]
    end.to_h
  end
  # rubocop:enable Style/ClassVars

  # This is a separate method to make it easy to replace in tests.
  def extra_slug
    extra_slugs[id]
  end

  def slug
    source_slug || extra_slug
  end
end
