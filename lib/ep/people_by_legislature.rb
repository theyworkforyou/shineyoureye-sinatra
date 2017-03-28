# frozen_string_literal: true
require_relative 'everypolitician_extensions'
require_relative 'person'

module EP
  class PeopleByLegislature
    def initialize(legislature:, mapit:, baseurl:)
      @legislature = legislature
      @mapit = mapit
      @baseurl = baseurl
    end

    def find_all
      @find_all ||= people_sorted_by_name.map { |person| create_person(person) }
    end

    def find_single(id)
      id_to_person[id]
    end

    def none?(id)
      find_single(id).nil?
    end

    def find_all_by_mapit_area(mapit_id)
      find_all.select { |person| person.area.id == mapit_id if person.area }
    end

    def current_term_start_date
      latest_term.start_date
    end

    def legislature_name
      legislature.name
    end

    def featured_person(featured_summaries)
      featured_summaries.map { |summary| find_single(summary.slug) }.compact.first
    end

    private

    attr_reader :legislature, :mapit, :baseurl

    def people_sorted_by_name
      latest_term.people.sort_by { |person| [person.sort_name, person.name] }
    end

    def latest_term
      legislature.legislative_periods.sort_by(&:start_date).last
    end

    def id_to_person
      @id_to_person ||= find_all.map { |person| [person.id, person] }.to_h
    end

    def create_person(person)
      Person.new(person: person, term: latest_term, mapit: mapit, baseurl: baseurl)
    end
  end
end
