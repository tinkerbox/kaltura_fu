module KalturaFu
  module Configuration
  
    @@config = {}
    @@client = nil
    @@client_configuration = nil
    @@session_key = nil
  
    def config
      @@config ||= {}
    end
    
    def config=(value)
      @@config = value
    end
    
    def client
      @@client ||= nil
    end
    
    def client=(value)
      @@client = value
    end
  
    def client_configuration
      @@client_configuration ||= nil
    end
    def client_configuration=(value)
      @@client_configuration = value
    end
    def session_key
      @@session_key ||=nil
    end
    
    
    ##
    # @private
    ##
    def create_client_config
      raise "Missing Partner Identifier" unless @@config[:partner_id]
      @@client_configuration = Kaltura::Configuration.new(@@config[:partner_id])
      unless @@config[:service_url].nil?
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
      
      raise "Missing Administrator Secret" unless @@config[:administrator_secret]
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