module KalturaFu
  module Session

    @@client = nil #An insantiated Kaltura::Client class 
    @@client_configuration = nil #Configuration values for the @@client.
    @@session_key = nil #The Kaltura ks to use.

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
      raise "Missing Partner Identifier" unless KalturaFu.config.partner_id
      @@client_configuration = Kaltura::Configuration.new(KalturaFu.config.partner_id)
      @@client_configuration.service_url = KalturaFu.config.service_url
  
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
  
      raise "Missing Administrator Secret" unless KalturaFu.config.administrator_secret
      @@session_key = @@client.session_service.start(KalturaFu.config.administrator_secret,'',Kaltura::Constants::SessionType::ADMIN)
      @@client.ks = @@session_key
    rescue Kaltura::APIError => e
      puts e.message      
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