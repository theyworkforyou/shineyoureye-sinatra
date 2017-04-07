# frozen_string_literal: true
require 'csv'
require_relative 'person'

module MembershipCSV
  class People
    def initialize(csv_filename:, person_factory:)
      @csv_filename = csv_filename
      @person_factory = person_factory
    end

    def find_all
      all_people.sort_by(&:name)
    end

    def find_single(slug)
      slug_to_person[slug]
    end

    def find_all_by_mapit_area(mapit_id)
      mapit_id_to_person[mapit_id.to_s] || []
    end

    def current_term_start_date; end

    def legislature_name; end

    def featured_person(featured_summaries)
      featured_summaries.map { |summary| id_to_person[summary.slug] }.compact.first
    end

    private

    attr_reader :csv_filename, :person_factory

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

    def slug_to_person
      @slug_to_person ||= all_people.map { |person| [person.slug, person] }.to_h
    end

    def mapit_id_to_person
      @mapit_id_to_person ||= all_people.each_with_object({}) { |person, memo| update_people_for_area(person, memo) }
    end

    def update_people_for_area(person, memo)
      return unless person.area
      (memo[person.area.id.to_s] ||= []) << person
    end

    def create_person(row)
      person_factory.build_csv_person(row)
    end
  end
end
