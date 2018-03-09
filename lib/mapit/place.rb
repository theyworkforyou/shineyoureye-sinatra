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

    def url
      "#{baseurl}#{pombola_slug}/"
    end

    private

    attr_reader :mapit_area_data, :pombola_slug, :baseurl
  end
end
