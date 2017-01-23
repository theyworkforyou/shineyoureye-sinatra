# frozen_string_literal: true

def normalize_slashes(path)
  # Squash consecutive slashes:
  path = path.gsub(%r{\/+/}, '/')
  # Strip leading and trailing slashes:
  path.gsub!(%r{^\/*(.*?)\/*$}, '\1')
end

def all_path_prefixes(path)
  path_parts = normalize_slashes(path).split('/')
  path_parts.map.with_index do |path_part, i|
    ['/' + path_parts.take(i + 1).join('/'), path_part]
  end.unshift(['/', nil])
end

def make_breadcrumbs(path, prefix_map)
  prefix_map = { '/' => 'Home' }.merge(prefix_map)
  # Attempt to get the human readable name for each path prefix,
  # or default to the path component itself:
  breadcrumbs = all_path_prefixes(path).map do |path_prefix, path_part|
    [path_prefix, prefix_map.fetch(path_prefix, path_part)]
  end
  # If the prefix_map stores nil for a particular prefix, that means
  # the breadcrumb should be omitted entirely:
  breadcrumbs.reject { |_, link_text| link_text.nil? }
end
