# frozen_string_literal: true
module SettingsHelper
  def house
    settings.index.country('Nigeria').legislature('Representatives')
  end

  def mapit_url
    settings.mapit_url
  end

  def twitter_user
    settings.twitter_user
  end
end

helpers SettingsHelper
