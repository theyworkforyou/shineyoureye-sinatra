# frozen_string_literal: true
require_relative '../person_proxy_images'

module EP
  class Person
    def initialize(person:, term:, mapit:, baseurl:)
      @person = person
      @term = term
      @mapit = mapit
      @baseurl = baseurl
    end

    extend Forwardable
    def_delegators :@person, :id, :name, :birth_date, :phone,
                             :email, :twitter, :facebook, :memberships

    include PersonProxyImages

    def twitter_display
      "@#{twitter}" if twitter
    end

    def twitter_url
      "https://twitter.com/#{twitter}" if twitter
    end

    def facebook_display
      facebook.split('/').last if facebook
    end

    def facebook_url
      facebook
    end

    def wikipedia_url
      link = person.links.find { |l| l[:note] == 'Wikipedia (en)' }
      link[:url] if link
    end

    def email_url
      "mailto:#{email}" if email
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

    def party_url
      "/organisation/#{party_id.downcase}/"
    end

    def url
      baseurl + id + '/'
    end

    private

    attr_reader :person, :term, :mapit, :baseurl

    def ep_area
      current_memberships.first.area
    end

    def legislature
      term.legislature
    end

    def proxy_image_url
      'https://theyworkforyou.github.io/shineyoureye-images' \
      "/#{legislature.slug}/#{id}/"
    end
  end
end
