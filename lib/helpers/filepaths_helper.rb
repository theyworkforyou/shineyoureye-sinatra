# frozen_string_literal: true
require_relative '../mapit/mappings'

module FilepathsHelper
  def mappings
    Mapit::Mappings.new(
      fed_to_sta_ids_mapping_filename: './mapit/fed_to_sta_area_ids_mapping.csv',
      pombola_slugs_to_mapit_ids_filename: './mapit/pombola_place_slugs_to_mapit.csv',
      mapit_to_ep_areas_fed_filename: './mapit/mapit_to_ep_area_ids_mapping_FED.csv',
      mapit_to_ep_areas_sen_filename: './mapit/mapit_to_ep_area_ids_mapping_SEN.csv'
    )
  end

  def content_dir
    settings.content_dir
  end

  def events_dir
    "#{content_dir}/events"
  end

  def info_dir
    "#{content_dir}/info"
  end

  def posts_dir
    "#{content_dir}/posts"
  end

  def events_pattern
    "#{events_dir}/#{date_glob}-*.md"
  end

  def event_pattern(slug)
    "#{events_dir}/#{date_glob}-#{slug}.md"
  end

  def info_pattern(slug)
    "#{info_dir}/#{slug}.md"
  end

  def posts_pattern
    "#{posts_dir}/#{date_glob}-*.md"
  end

  def post_pattern(slug)
    "#{posts_dir}/#{date_glob}-#{slug}.md"
  end

  private

  def date_glob
    '[0-9][0-9][0-9][0-9]-[0-9][0-9]-[0-9][0-9]'
  end
end

helpers FilepathsHelper
