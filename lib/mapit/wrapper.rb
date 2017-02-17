# frozen_string_literal: true
require_relative 'place'

module Mapit
  class Wrapper
    def initialize(mapit_url:, mapit_mappings:, baseurl:)
      @mapit_url = mapit_url
      @mapit_mappings = mapit_mappings
      @baseurl = baseurl
    end

    def states
      sta.values
    end

    def federal_constituencies
      fed.values
    end

    def senatorial_districts
      sen.values
    end

    def area_from_ep_id(id)
      sta.merge(fed).merge(sen)[ep_to_mapit_ids[id]]
    end

    private

    attr_reader :mapit_url, :mapit_mappings, :baseurl

    def sta
      @sta ||= areas('STA').map { |id, area| [id, create_place(area)] }.to_h
    end

    def fed
      @fed ||= areas('FED').map { |id, area| [id, create_place(area, parent(area))] }.to_h
    end

    def sen
      @sen ||= areas('SEN').map { |id, area| [id, create_place(area, parent(area))] }.to_h
    end

    def areas(area_type)
      uri = URI(mapit_url + area_type)
      JSON.parse(Net::HTTP.get(uri))
    end

    def parent(area)
      parent_id = child_to_sta_mapping[area['id'].to_s]
      sta[parent_id]
    end

    def pombola_slug(area)
      mapit_ids_to_pombola_slugs[area['id'].to_s]
    end

    def mapit_ids_to_pombola_slugs
      mapit_mappings.mapit_ids_to_pombola_slugs
    end

    def child_to_sta_mapping
      mapit_mappings.fed_to_sta_mapping.merge(mapit_mappings.sen_to_sta_mapping)
    end

    def ep_to_mapit_ids
      mapit_mappings.ep_to_mapit_ids
    end

    def create_place(area, parent_area = nil)
      Mapit::Place.new(
        place: area,
        parent: parent_area,
        pombola_slug: pombola_slug(area),
        baseurl: baseurl
      )
    end
  end
end
