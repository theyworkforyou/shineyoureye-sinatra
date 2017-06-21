# frozen_string_literal: true

def missing_slug_row(person, collection)
  return nil if person.slug
  {
    uuid: person.id,
    name: person.name,
    legislature_name: collection.legislature_name,
    suggested_slug: person.name.downcase.strip.gsub(/\s+/, '-').gsub(/[^\w-]/, '')
  }
end

def missing_slugs_rows(*collections)
  collections.flat_map do |collection|
    collection.find_all.map { |person| missing_slug_row(person, collection) }.compact
  end
end

# Find any people without slugs and report them:
def raise_if_missing_slugs(*collections)
  rows = missing_slugs_rows(*collections)
  return if rows.empty?
  CSV.open('missing-slugs.csv', 'wb') do |csv|
    csv << rows.first.keys
    rows.each do |row|
      csv << row.values
    end
  end
  raise 'Some people were missing slugs: see missing-slugs.csv'
end
