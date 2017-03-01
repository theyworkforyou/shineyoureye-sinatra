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

    private

    attr_reader :csv_filename, :mapit, :baseurl

    def all_people
      @all_people ||= read_with_headers.map { |row| create_person(remove_empty_cells(row)) }
    end

    def remove_empty_cells(row)
      row.reject { |header, value| value.nil? || value.empty? }.to_h
    end

    def read_with_headers
      CSV.read(csv_filename, headers: :first_row)
    end

    def id_to_person
      @id_to_person ||= all_people.map { |person| [person.id, person] }.to_h
    end

    def create_person(row)
      Person.new(person: row, mapit: mapit, baseurl: baseurl)
    end
  end
end
