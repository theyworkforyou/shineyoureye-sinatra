# frozen_string_literal: true

module Mapit
  class Place
    attr_accessor :parent

    def initialize(mapit_area_data:, pombola_slug:, baseurl:, parent: nil)
      @mapit_area_data = mapit_area_data
      @pombola_slug = pombola_slug
      @baseurl = baseurl
      @parent = parent
    end

    def id
      mapit_area_data['id']
    end

    def name
      mapit_area_data['name']
    end

    def type_name
      mapit_area_data['type_name']
    end

    alias child_area? parent

    def state
      if type_name == 'State'
        self
      elsif parent && parent.type_name == 'State'
        parent
      end
    end

    def thumbnail_url
      if File.exist?("public/images/thumbnails/#{pombola_slug}.jpg")
        "/images/thumbnails/#{pombola_slug}.jpg"
      else
        '/images/place-250x250.png'
      end
    end

    def url
      "#{baseurl}#{pombola_slug}/"
    end

    def place_url
      "#{pombola_slug}/"
    end

    private

    attr_reader :mapit_area_data, :pombola_slug, :baseurl
  end
end
