# frozen_string_literal: true

module PersonSocial
  def twitter_display
    "@#{twitter}" if twitter
  end

  def twitter_url
    "https://twitter.com/#{twitter}" if twitter
  end

  def facebook_display
    facebook&.split('/')&.last
  end

  def facebook_url
    facebook
  end

  def email_url
    "mailto:#{email}" if email
  end
end
