# frozen_string_literal: true
require 'csv'

module Mapit
  class Mappings
    def initialize(
      parent_mapping_filenames: [],
      pombola_slugs_to_mapit_ids_filename: nil,
      mapit_to_ep_areas_filenames: []
    )
      @parent_mapping_filenames = parent_mapping_filenames
      @pombola_slugs_to_mapit_ids_filename = pombola_slugs_to_mapit_ids_filename
      @mapit_to_ep_areas_filenames = mapit_to_ep_areas_filenames
    end

    def child_to_parent
      # We assume each child has a single parent (which is true of
      # MapIt Area objects, which these will be).
      @child_to_parent ||= all_parent_mappings_array.to_h
    end

    def pombola_slugs_to_mapit_ids
      @pombola_to_mapit ||= pombola_slugs_to_mapit_ids_without_type.to_h
    end

    def mapit_ids_to_pombola_slugs
      @mapit_ids_to_pombola_slugs ||= reverse(pombola_slugs_to_mapit_ids_without_type).to_h
    end

    def ep_to_mapit_ids
      @ep_to_mapit_ids ||= reverse_ep_to_mapit_ids.to_h
    end

    private

    attr_reader :parent_mapping_filenames,
                :pombola_slugs_to_mapit_ids_filename,
                :mapit_to_ep_areas_filenames

    # The Pombola to Mapit CSV file contains three columns: Pombola
    # slug, Mapit id, area type (FED, SEN or STA) We don't need the
    # last column (with the type) for this mapping.
    def pombola_slugs_to_mapit_ids_without_type
      @pombola_slugs_to_mapit_ids_without_type ||= \
        pombola_slugs_to_mapit_ids_data.map { |row| row[0..-2] }
    end

    def pombola_slugs_to_mapit_ids_data
      return [] unless pombola_slugs_to_mapit_ids_filename
      read(pombola_slugs_to_mapit_ids_filename)
    end

    def all_parent_mappings_array
      parent_mapping_filenames.flat_map { |filename| read(filename) }
    end

    def reverse_ep_to_mapit_ids
      mapit_to_ep_areas_filenames.flat_map do |filename|
        reverse(read(filename))
      end
    end

    def reverse(mapping_list)
      mapping_list.map(&:reverse)
    end

    def read(filename)
      CSV.read(filename)
    end
  end
end
