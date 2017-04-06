# frozen_string_literal: true
require_relative '../ep/person'
require_relative '../membership_csv/person'

module Factory
  class Person
    def initialize(mapit:, baseurl:, identifier_scheme:)
      @mapit = mapit
      @baseurl = baseurl
      @identifier_scheme = identifier_scheme
    end

    def build_ep_person(person, term)
      EP::Person.new(
        person: person,
        term: term,
        mapit: mapit,
        baseurl: baseurl,
        identifier_scheme: identifier_scheme
      )
    end

    def build_csv_person(person)
      MembershipCSV::Person.new(
        person: person,
        mapit: mapit,
        baseurl: baseurl,
        identifier_scheme: identifier_scheme
      )
    end

    private

    attr_reader :mapit, :baseurl, :identifier_scheme
  end
end
