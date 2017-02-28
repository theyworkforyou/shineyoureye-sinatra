# frozen_string_literal: true
module Morph
  class Person
    def initialize(person:, mapit:, baseurl:)
      @person = person
      @mapit = mapit
      @baseurl = baseurl
    end

    def id
      person['id']
    end

    def name
      person['name']
    end

    def birth_date
      person['birth_date'] if person['birth_date']
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

    def thumbnail_image_url
      proxy_image_variant(:thumbnail)
    end

    def medium_image_url
      proxy_image_variant(:medium)
    end

    def original_image_url
      proxy_image_variant(:original)
    end

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
      nil
    end

    def email_url
      "mailto:#{email}" if email
    end

    def area
      mapit.area_from_morph_name(person['state'])
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

    def url
      baseurl + person['identifier__shineyoureye'] + '/'
    end

    private

    attr_reader :person, :mapit, :baseurl

    ALLOWED_IMAGE_SIZES = {
      thumbnail: '100x100',
      medium: '250x250',
      original: 'original'
    }

    def proxy_image_variant(size)
      raise_unless_image_size_available(size)
      'https://raw.githubusercontent.com/theyworkforyou/shineyoureye-images' \
      "/gh-pages/Governors/#{id}/#{ALLOWED_IMAGE_SIZES[size]}.jpeg"
    end

    def raise_unless_image_size_available(size)
      unless ALLOWED_IMAGE_SIZES.has_key?(size)
        raise "Size #{size} is not known to be available"
      end
    end

    def first(values)
      values.split(';').first
    end
  end
end
