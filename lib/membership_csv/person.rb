# frozen_string_literal: true

require_relative '../person_proxy_images'
require_relative '../person_social'
require_relative '../person_slug'

module MembershipCSV
  class Person
    def initialize(person:, legislature:, mapit:, baseurl:, identifier_scheme:)
      @person = person
      @legislature = legislature
      @mapit = mapit
      @baseurl = baseurl
      @identifier_scheme = identifier_scheme
    end

    include PersonProxyImages
    include PersonSocial
    include PersonSlug

    def id
      person['id']
    end

    def name
      person['name']
    end

    def image
      person['image_url']
    end

    def birth_date
      person['birth_date']
    end

    def phone
      person['phone']&.split(';')&.join(', ')
    end

    def email
      first(person['email']) if person['email']
    end

    def twitter
      first(person['twitter']) if person['twitter']
    end

    def facebook
      first(person['facebook_url']) if person['facebook_url']
    end

    def wikipedia_url
      nil
    end

    def area
      if person['mapit_id']
        mapit.area_from_mapit_id(person['mapit_id'])
      elsif person['state']
        mapit.area_from_mapit_name(person['state'])
      end
    end

    def party_id
      person['party']
    end

    def party_name
      person['party']
    end

    def source_slug
      person["identifier__#{identifier_scheme}"]
    end

    def url
      baseurl + slug + '/' if slug
    end

    private

    attr_reader :person, :legislature, :mapit, :baseurl, :identifier_scheme

    def first(values)
      values.split(';').first
    end

    def proxy_image_base_url
      'https://raw.githubusercontent.com/theyworkforyou/shineyoureye-images' \
      "/gh-pages/#{legislature.slug}/#{id}/"
    end
  end
end
