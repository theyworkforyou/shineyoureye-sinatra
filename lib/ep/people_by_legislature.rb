# frozen_string_literal: true
require_relative 'everypolitician_extensions'
require_relative 'person'

module EP
  class PeopleByLegislature
    def initialize(legislature:, person_factory:)
      @legislature = legislature
      @person_factory = person_factory
    end

    def find_all
      @find_all ||= people_sorted_by_name.map { |person| create_person(person) }
    end

    def find_single(slug)
      slug_to_person[slug]
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
      featured_summaries.map { |summary| id_to_person[summary.slug] }.compact.first
    end

    private

    attr_reader :legislature, :person_factory

    def people_sorted_by_name
      latest_term.people.sort_by { |person| [person.sort_name, person.name] }
    end

    def latest_term
      legislature.legislative_periods.sort_by(&:start_date).last
    end

    def id_to_person
      @id_to_person ||= find_all.map { |person| [person.id, person] }.to_h
    end

    def slug_to_person
      @slug_to_person ||= find_all.each_with_object({}) { |person, memo| ensure_unique_slug(person, memo) }
    end

    def ensure_unique_slug(person, memo)
      raise_if_no_slug(person)
      raise_if_repeated_slug(person, memo)
      memo[person.slug] = person
    end

    def raise_if_no_slug(person)
      raise "No slug for #{person.name}" unless person.slug
    end

    def raise_if_repeated_slug(person, memo)
      raise "Slug #{person.slug} repeated for #{memo[person.slug].name} and #{person.name}" if memo[person.slug]
    end

    def create_person(person)
      person_factory.build_ep_person(person, latest_term)
    end
  end
end
