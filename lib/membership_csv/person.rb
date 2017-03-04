# frozen_string_literal: true
require_relative '../person_proxy_images'
require_relative '../person_social'

module MembershipCSV
  class Person
    def initialize(person:, mapit:, baseurl:)
      @person = person
      @mapit = mapit
      @baseurl = baseurl
    end

    include PersonProxyImages
    include PersonSocial

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
      person['phone'].split(';').join(', ') if person['phone']
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
      mapit.area_from_mapit_name(person['state'])
    end

    def party_id
      person['party']
    end

    def party_name
      person['party']
    end

    def party_url
      "/organisation/#{person['party'].downcase}/"
    end

    def slug
      person['identifier__shineyoureye']
    end

    def url
      baseurl + id + '/' if id
    end

    private

    attr_reader :person, :mapit, :baseurl

    def first(values)
      values.split(';').first
    end

    def proxy_image_base_url
      'https://raw.githubusercontent.com/theyworkforyou/shineyoureye-images' \
      "/gh-pages/Governors/#{id}/"
    end
  end
end