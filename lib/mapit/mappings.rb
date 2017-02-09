# frozen_string_literal: true
require 'csv'

module Mapit
  class Mappings
    def initialize(
      fed_to_sta_ids_mapping_filename:,
      pombola_slugs_to_mapit_ids_filename:
    )
      @fed_to_sta_ids_mapping_filename = fed_to_sta_ids_mapping_filename
      @pombola_slugs_to_mapit_ids_filename = pombola_slugs_to_mapit_ids_filename
    end

    def fed_to_sta_mapping
      @fed_to_sta_mapping ||= CSV.read(fed_to_sta_ids_mapping_filename).to_h
    end

    def mapit_ids_to_pombola_slugs
      @mapit_ids_to_pombola_slugs ||= reverse_pombola_slugs_to_mapit_ids.to_h
    end

    private

    attr_reader :fed_to_sta_ids_mapping_filename, :pombola_slugs_to_mapit_ids_filename

    def reverse_pombola_slugs_to_mapit_ids
      CSV.read(pombola_slugs_to_mapit_ids_filename).map { |row| [row[1], row.first] }
    end
  end
end
