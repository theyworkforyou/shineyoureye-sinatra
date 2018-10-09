#!/usr/bin/env ruby
# frozen_string_literal: true

require 'cgi'
require 'csv'
require 'date'
require 'everypolitician'
require 'open-uri'

unless ENV['MORPH_API_KEY']
  puts "You must set MORPH_API_KEY in order to download the scraper's output."
  exit(1)
end

CSV_URL = 'https://morph.io/everypolitician-scrapers/' \
          'nigeria-shineyoureye-positions/data.csv' \
          "?key=#{CGI.escape(ENV['MORPH_API_KEY'])}" \
          '&query=select+%2A+from+%27data%27'

people = CSV.new(File.open(CSV_URL), headers: :first_row).group_by do |row|
  raise 'A person_slug was missing in the data' unless row['person_slug']

  row['person_slug']
end

def slug_to_uuid_for_house(house)
  map = {}
  house.latest_term.memberships.map(&:person).uniq(&:id).each do |person|
    identifier_sye = person.identifiers.find { |i| i[:scheme] == 'shineyoureye' }
    map[identifier_sye[:identifier]] = person.id if identifier_sye
  end
  map
end

def build_slug_to_uuid
  map = {}
  ep_index = EveryPolitician::Index.new
  %w[Representatives Senate].each do |house_name|
    house = ep_index.country('Nigeria').legislature(house_name)
    map.merge(slug_to_uuid_for_house(house))
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
  d.strftime('%-d %B %Y')
end

def only_end(start_date, end_date)
  start_date.empty? && !end_date.empty?
end

def only_start(start_date, end_date)
  end_date.empty? && !start_date.empty?
end

def both_start_and_end(start_date, end_date)
  !start_date.empty? && !end_date.empty?
end

def formatted_date_range(start_date, end_date)
  if only_end(start_date, end_date)
    " until #{format_date(end_date)}"
  elsif only_start(start_date, end_date)
    " starting at #{format_date(start_date)}"
  elsif both_start_and_end(start_date, end_date)
    " from #{format_date(start_date)} to #{format_date(end_date)}"
  else
    ''
  end
end

def get_markdown_for_position(position)
  start_date = position['start_date']
  end_date = position['end_date']
  role = position['role']
  organization = position['organization_name']
  return if position['organization_classification'].include? 'Party'
  return if organization.empty?
  return if role.empty?

  bullet_item = "* #{role} at #{organization}"
  bullet_item += formatted_date_range(start_date, end_date)
  bullet_item + "\n"
end

def get_markdown_from_rows(positions)
  return nil if positions.empty?

  result = positions[0]['person_summary'].strip
  result += "\n\n" unless result.empty?
  positions.each do |position|
    position_markdown = get_markdown_for_position(position)
    result += position_markdown if position_markdown
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
  File.open(filename, 'w') do |f|
    f.write("---\n")
    f.write("featured: false\n")
    f.write("published: true\n")
    f.write("---\n")
    f.write(get_markdown_from_rows(positions))
  end
end
