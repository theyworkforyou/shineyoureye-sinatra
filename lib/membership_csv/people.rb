# frozen_string_literal: true
require 'csv'
require_relative 'person'

module MembershipCSV
  class People
    def initialize(csv_filename:, mapit:, baseurl:)
      @csv_filename = csv_filename
      @mapit = mapit
      @baseurl = baseurl
    end

    def find_all
      all_people.sort_by(&:name)
    end

    def find_single(id)
      id_to_person[id]
    end

    def none?(id)
      find_single(id).nil?
    end

    def find_all_by_mapit_area(mapit_id)
      mapit_id_to_person[mapit_id.to_s] || []
    end

    def none_by_mapit_area?(mapit_id)
      find_all_by_mapit_area(mapit_id).empty?
    end

    def current_term_start_date
      nil
    end

    def legislature_name
      nil
    end

    def featured_person(featured_summaries)
      featured_summaries.map { |summary| find_single(summary.slug) }.compact.first
    end

    private

    attr_reader :csv_filename, :mapit, :baseurl

    def all_people
      @all_people ||= read_with_headers.map { |row| create_person(remove_empty_cells(row)) }
    end

    def remove_empty_cells(row)
      row.reject { |_header, value| value.nil? || value.empty? }.to_h
    end

    def read_with_headers
      CSV.read(csv_filename, headers: :first_row)
    end

    def id_to_person
      @id_to_person ||= all_people.map { |person| [person.id, person] }.to_h
    end

    def mapit_id_to_person
      @mapit_id_to_person ||= all_people.each_with_object({}) { |person, memo| update_people_for_area(person, memo) }
    end

    def update_people_for_area(person, memo)
      return unless person.area
      (memo[person.area.id.to_s] ||= []) << person
    end

    def create_person(row)
      Person.new(person: row, mapit: mapit, baseurl: baseurl)
    end
  end
end
