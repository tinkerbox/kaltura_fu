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
  
  @@client = nil #An insantiated Kaltura::Client class 
  @@client_configuration = nil #Configuration values for the @@client.
  @@session_key = nil #The Kaltura ks to use.  
  
  def self.config
    Configuration.instance
  end
  
  def self.configure
    yield config
  end
  
  def self.client
    @@client ||= nil
  end
  
  def self.client=(value)
    @@client = value
  end

  def self.client_configuration
    @@client_configuration ||= nil
  end
  def self.client_configuration=(value)
    @@client_configuration = value
  end
  def self.session_key
    @@session_key ||=nil
  end
  
  
  ##
  # @private
  ##
  def self.create_client_config
    raise "Missing Partner Identifier" unless Configuration.instance.partner_id
    @@client_configuration = Kaltura::Configuration.new(Configuration.instance.partner_id)
    @@client_configuration.service_url = Configuration.instance.service_url
    
    @@client_configuration
  end

  ##
  # @private
  ##
  def self.create_client
    if @@client_configuration.nil?
      self.create_client_config
    end
    @@client = Kaltura::Client.new(@@client_configuration)
    @@client
  end

  ##
  # Generates a Kaltura ks and adds it to the KalturaFu client object.
  #
  # @return [String] a Kaltura KS.
  ## 
  def self.generate_session_key
    self.check_for_client_session
    
    raise "Missing Administrator Secret" unless Configuration.instance.administrator_secret
    @@session_key = @@client.session_service.start(Configuration.instance.administrator_secret,'',Kaltura::Constants::SessionType::ADMIN)
    @@client.ks = @@session_key
  rescue Kaltura::APIError => e
    puts e.message      
  end
  
  ##
  # Clears the current Kaltura ks.
  ##
  def self.clear_session_key!
    @@session_key = nil
  end

  ##
  # @private
  ##
  def self.check_for_client_session
    if @@client.nil?
      self.create_client
      self.generate_session_key
      true
    else
      true
    end
  end  
  
end