# frozen_string_literal: true
module EP
  class Person
    def initialize(person:, term:, mapit:, baseurl:)
      @person = person
      @term = term
      @mapit = mapit
      @baseurl = baseurl
    end

    extend Forwardable
    def_delegators :@person, :id, :name, :image, :birth_date, :phone,
                             :email, :twitter, :facebook, :memberships

    def proxy_image
      'https://theyworkforyou.github.io/shineyoureye-images' \
      "/#{legislature.slug}/#{id}/100x100.jpeg"
    end

    def twitter_display
      "@#{twitter}"
    end

    def twitter_url
      "https://twitter.com/#{twitter}"
    end

    def facebook_display
      facebook.to_s.split('/').last
    end

    def facebook_url
      facebook
    end

    def email_url
      "mailto:#{email}"
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
  end
end
