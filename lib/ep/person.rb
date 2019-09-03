# frozen_string_literal: true

require_relative '../person_proxy_images'
require_relative '../person_social'
require_relative '../person_slug'

module EP
  class Person
    def initialize(person:, term:, mapit:, baseurl:, identifier_scheme:)
      @person = person
      @term = term
      @mapit = mapit
      @baseurl = baseurl
      @identifier_scheme = identifier_scheme
    end

    extend Forwardable
    def_delegators :@person,
                   :id, :name, :birth_date, :image, :phone,
                   :email, :twitter, :facebook, :memberships

    include PersonProxyImages
    include PersonSocial
    include PersonSlug

    def wikipedia_url
      person.link('Wikipedia (en)')
    end

    def current_memberships
      memberships.where(legislative_period_id: term.id)
    end

    def area
      mapit.area_from_ep_id(ep_area.id)
    end

    def party_id
      current_memberships.first.party.id
    end

    def party_name
      current_memberships.first.party.name
    end

    def url
      baseurl + slug + '/'
    end

    def source_slug
      person.identifier(identifier_scheme)
    end

    private

    attr_reader :person, :term, :mapit, :baseurl, :identifier_scheme

    def ep_area
      current_memberships.first.area
    end

    def legislature
      term.legislature
    end

    def proxy_image_base_url
      'https://theyworkforyou.github.io/shineyoureye-images' \
      "/#{legislature.slug}/#{id}/"
    end
  end
end
