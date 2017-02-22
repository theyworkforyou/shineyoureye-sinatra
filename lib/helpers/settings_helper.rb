# frozen_string_literal: true
module SettingsHelper
  def twitter_user
    settings.twitter_user
  end
end

helpers SettingsHelper
