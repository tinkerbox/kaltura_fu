# Set up the following configuration with environment variables (Recommended)
#
# Obtain your Kaltura API publisher credentials via the KMC Integration Settings
# http://www.kaltura.com/index.php/kmc/kmc4#account|integration
#

KalturaFu.configure do |config|
  config.login_email = ENV["USER_EMAIL"]
  config.login_password = ENV["THE_PASSWORD"]
  config.partner_id = ENV["PARTNER_ID"]
  config.subpartner_id = ENV["PARTNER_ID"].to_i * 100
  config.administrator_secret = ENV["ADMINISTRATOR_SECRET"]
  config.user_secret = ENV["USER_SECRET"]
  config.thumb_width = "300"
  config.thumb_height = "300"
  config.player_conf_id = ENV["whatever"]
  config.service_url = "http://www.kaltura.com"
end
