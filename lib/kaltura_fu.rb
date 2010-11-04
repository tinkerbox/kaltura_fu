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
require 'rubygems'
require 'kaltura'

module KalturaFu
  
  #Initilize the configuration and send the ViewHelpers into ActionView::Base when it's a Rails 3 app.
  require 'kaltura_fu/railtie' if defined?(Rails) && Rails.version.split(".").first == "3"
  
  autoload :Video, 'kaltura_fu/video'
  autoload :Category, 'kaltura_fu/category'
  autoload :Report, 'kaltura_fu/report'
  autoload :Configuration, 'kaltura_fu/configuration'
  autoload :Entry, 'kaltura_fu/entry'
  
  module Entry
    autoload :Metadata, 'kaltura_fu/entry/metadata'
    autoload :ClassMethods, 'kaltura_fu/entry/class_methods'
    autoload :InstanceMethods, 'kaltura_fu/entry/instance_methods'
    
    module Metadata
      autoload :ClassMethods, 'kaltura_fu/entry/metadata/class_methods'
      autoload :ClassAndInstanceMethods, 'kaltura_fu/entry/metadata/class_and_instance_methods'
    end
  end
  
  extend Configuration
end
