require 'singleton'

module KalturaFu
  class Configuration
    include Singleton
  
    @@defaults = {
      :login_email => 'USER_EMAIL',
      :login_password => 'THE_PASSWORD',
      :partner_id => 'PARTNER_ID',
      :subpartner_id => 'PARTNER_ID * 100',
      :administrator_secret => 'ADMINISTRATOR_SECRET',
      :user_secret => 'USER_SECRET', 
      :thumb_width => '300',
      :thumb_height => '300',
      :player_conf_id => 'whatever',
      :service_url => 'http://www.kaltura.com'
    }
    
    attr_accessor :login_email, :login_password, :partner_id, :subpartner_id,
                  :administrator_secret, :user_secret, :thumb_width, :thumb_height,
                  :player_conf_id, :service_url
  
    def self.defaults
      @@defaults
    end
    
    def initialize
      @@defaults.each_pair{|k,v| self.send("#{k}=",v)}
    end    
    
  end
  
  def self.config
    Configuration.instance
  end
  
  def self.configure
    yield config
  end
end