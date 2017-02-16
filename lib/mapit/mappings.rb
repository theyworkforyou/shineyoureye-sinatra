# frozen_string_literal: true
require 'csv'

module Mapit
  class Mappings
    def initialize(
      fed_to_sta_ids_mapping_filename:,
      pombola_slugs_to_mapit_ids_filename:,
      mapit_to_ep_areas_fed_filename:,
      mapit_to_ep_areas_sen_filename:
    )
      @fed_to_sta_ids_mapping_filename = fed_to_sta_ids_mapping_filename
      @pombola_slugs_to_mapit_ids_filename = pombola_slugs_to_mapit_ids_filename
      @mapit_to_ep_areas_fed_filename = mapit_to_ep_areas_fed_filename
      @mapit_to_ep_areas_sen_filename = mapit_to_ep_areas_sen_filename
    end

    def fed_to_sta_mapping
      @fed_to_sta_mapping ||= read(fed_to_sta_ids_mapping_filename).to_h
    end

    def pombola_slugs_to_mapit_ids
      @pombola_slugs_to_mapit_ids ||= pombola_slugs_to_mapit_ids_ignore_last.to_h
    end

    def mapit_ids_to_pombola_slugs
      @mapit_ids_to_pombola_slugs ||= reverse(pombola_slugs_to_mapit_ids_ignore_last).to_h
    end

    def ep_to_mapit_ids
      @ep_to_mapit_ids ||= reverse_ep_to_mapit_ids.to_h
    end

    private

    attr_reader :fed_to_sta_ids_mapping_filename, :pombola_slugs_to_mapit_ids_filename,
                :mapit_to_ep_areas_fed_filename, :mapit_to_ep_areas_sen_filename

    # The Pombola to Mapit CSV file contains three columns:
    # Pombola slug, Mapit id, area type (FED, SEN or STA)
    # We don't need the last column for this mapping
    def pombola_slugs_to_mapit_ids_ignore_last
      @pombola_to_mapit ||= read(pombola_slugs_to_mapit_ids_filename).map { |row| row[0..-2] }
    end

    def reverse_ep_to_mapit_ids
      reverse(read(mapit_to_ep_areas_fed_filename)) +
      reverse(read(mapit_to_ep_areas_sen_filename))
    end

    def reverse(mapping_list)
      mapping_list.map { |row| row.reverse }
    end

    def read(filename)
      CSV.read(filename)
    end
  end
end
