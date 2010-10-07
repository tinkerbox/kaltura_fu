require 'kaltura_fu/video'
require 'kaltura_fu/category'
require 'kaltura_fu/report'

##
# @private
##
class Hash
  
  ##
  # @private
  ##
  def recursively_symbolize_keys
    tmp = {}
    for k, v in self
      tmp[k] = if v.respond_to? :recursively_symbolize_keys
                 v.recursively_symbolize_keys
               else
                 v
               end
    end
    tmp.symbolize_keys
  end
end

##
# The KalturaFu module provides a singleton implementation for Kaltura API interaction.  It stores session and API client information so that they do not need to be reset.
# @author Patrick Robertson
#
# @example Initilize a session:
#   KalturaFu.generate_session_key #=> "OTQyNzA2NzAxNzZmNDQyMTA1YzBiNzA5YWFjNzQ0ODNjODQ5MjZkM3wyMDM4MjI7MjAzODIyOzEyODUzNTA2ODg7MjsxMjg1MjY0Mjg4LjI2NTs7"
# @example Retrieve a client object:
#   client = KalturaFu.client #=> #<Kaltura::Client:0x1071e39f0 @session_service=#<Kaltura::Service::SessionService:0x1071e3900 @client=#<Kaltura::Client:0x1071e39f0 ...>>, @calls_queue=[], @should_log=false, @is_multirequest=false, @ks="OTQyNzA2NzAxNzZmNDQyMTA1YzBiNzA5YWFjNzQ0ODNjODQ5MjZkM3wyMDM4MjI7MjAzODIyOzEyODUzNTA2ODg7MjsxMjg1MjY0Mjg4LjI2NTs7", @config=#<Kaltura::Configuration:0x1071e39c8 @client_tag="ruby", @format=2, @service_url="http://www.kaltura.com", @partner_id="20322323", @timeout=10>>
# @example Clear a session:
#   KalturaFu.clear_session_key! #=> nil
##
module KalturaFu
  include KalturaFu::Video
  include KalturaFu::Category
  include KalturaFu::Report
  # Kaltura's ready state.
  READY = Kaltura::Constants::FlavorAssetStatus::READY
  
  
  @@config = {}
  @@client = nil
  @@client_configuration = nil
  @@session_key = nil
  mattr_reader :config
  mattr_reader :client
  mattr_reader :session_key
  
  class << self
    ##
    # @private
    ##
    def config=(options)
      @@config = options
    end
    
    ##
    # @private
    #
    def create_client_config
      @@client_configuration = Kaltura::Configuration.new(@@config[:partner_id])
      unless @@config[:service_url].blank?
        @@client_configuration.service_url = @@config[:service_url]
      end
      @@client_configuration
    end
    
    ##
    # @private
    ##
    def create_client
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
    def generate_session_key
      self.check_for_client_session
      
      @@session_key = @@client.session_service.start(@@config[:administrator_secret],'',Kaltura::Constants::SessionType::ADMIN)
      @@client.ks = @@session_key
    end
    ##
    # Clears the current Kaltura ks.
    ##
    def clear_session_key!
      @@session_key = nil
    end
    
    ##
    # @private
    ##
    def check_for_client_session
      if @@client.nil?
        self.create_client
        self.generate_session_key
        true
      else
        true
      end
    end
          
  end
end
