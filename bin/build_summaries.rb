#!/usr/bin/env ruby
# frozen_string_literal: true

require 'csv'
require 'date'
require 'everypolitician'
require 'open-uri'
require 'uri'

unless ENV['MORPH_API_KEY']
  puts "You must set MORPH_API_KEY in order to download the scraper's output."
  exit(1)
end

CSV_URL = 'https://morph.io/everypolitician-scrapers/' \
          'nigeria-shineyoureye-positions/data.csv' \
          "?key=#{URI.escape(ENV['MORPH_API_KEY'])}" \
          '&query=select+%2A+from+%27data%27'

people = CSV.new(open(CSV_URL), headers: :first_row).group_by do |row|
  raise 'A person_slug was missing in the data' unless row['person_slug']
  row['person_slug']
end

def build_slug_to_uuid
  map = {}
  ep_index = EveryPolitician::Index.new()
  %w(Representatives Senate).each do |house_name|
    house = ep_index.country('Nigeria').legislature(house_name)
    house.latest_term.memberships.map(&:person).uniq(&:id).each do |person|
      identifier_sye = person.identifiers.find { |i| i[:scheme] == 'shineyoureye' }
      if identifier_sye
        map[identifier_sye[:identifier]] = person.id
      end
    end
  end
  map
end

def format_date(partial_iso8601)
  return partial_iso8601 if partial_iso8601 =~ /^\d{4}$/
  if /^\d{4}-\d{2}/ =~ partial_iso8601
    d = Date.parse(partial_iso8601 + '-01')
    return d.strftime('%B %Y')
  end
  d = Date.parse(partial_iso8601)
  return d.strftime('%-d %B %Y')
end

def get_markdown_from_rows(positions)
  return nil if positions.empty?
  result = positions[0]['person_summary'].strip
  result += "\n\n" unless result.empty?
  for position in positions
    start_date = position['start_date']
    end_date = position['end_date']
    role = position['role']
    classification = position['organization_classification']
    organization = position['organization_name']
    category = position['organization_category']
    next if classification.include? 'Party'
    next if organization.empty?
    next if role.empty?
    result += "* #{role} at #{organization}"
    if start_date.empty? and not end_date.empty?
      result += " until #{format_date(end_date)}"
    elsif end_date.empty? and not start_date.empty?
      result += " starting at #{format_date(start_date)}"
    elsif (not start_date.empty?) and (not end_date.empty?)
      result += " from #{format_date(start_date)} to #{format_date(end_date)}"
    end
    result += "\n"
  end
  result += "\n"
end

slug_to_uuid = build_slug_to_uuid

people.each do |slug, positions|
  uuid = slug_to_uuid[slug]
  next unless uuid
  filename = File.join(
    File.dirname(__FILE__), '..', 'prose', 'summaries', "#{uuid}.md"
  )
  markdown = get_markdown_from_rows(positions)
  open(filename, 'w') do |f|
    f.write("---\n")
    f.write("featured: false\n")
    f.write("published: true\n")
    f.write("---\n")
    f.write(get_markdown_from_rows(positions))
  end
end
