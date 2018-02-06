# frozen_string_literal: true
require_relative 'lib/hash_to_object'

module SiteSpecificSettings
  def self.settings
    SITE_SPECIFIC_SETTINGS.to_object
  end

  SITE_SPECIFIC_SETTINGS = {
    contact_email: 'syeinfo@eienigeria.org',
    content_dir: File.join(__dir__, 'prose'),
    mapit_url: 'http://nigeria.mapit.mysociety.org',
    mapit_user_agent: ENV.fetch('MAPIT_USER_AGENT', nil),
    twitter_user: 'NGShineYourEye',
    mapit_settings: {
      baseurl: '/place/',
      area_types: %w(FED SEN STA),
      data_directory: 'mapit'
    }
  }.extend(HashToObject).freeze

  private_constant :SITE_SPECIFIC_SETTINGS
end
