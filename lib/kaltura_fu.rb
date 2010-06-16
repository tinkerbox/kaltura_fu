include Kaltura

class Hash
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

module KalturaFu
  @@config = {}
  @@client = nil
  @@client_configuration = nil
  @@session_key = nil
  mattr_reader :config
  mattr_reader :client
  mattr_reader :session_key
  
  #@@config[:partner_id] = kaltura['partner_id']


  class << self
    def config=(options)
      @@config = options
    end
    def create_client_config
      @@client_configuration = Kaltura::KalturaConfiguration.new(@@config[:partner_id])
      @@client_configuration
    end
    
    def create_client
      if @@client_configuration.nil?
        self.create_client_config
      end
      @@client = Kaltura::KalturaClient.new(@@client_configuration)
      @@client
    end
    
    def generate_session_key
      if @@client.nil?
        self.create_client
      end
      @@session_key = @@client.session_service.start(@@config[:administrator_secret],'',KalturaSessionType::ADMIN)
      @@client.ks = @@session_key
      @@session_key
    end
    
    def clear_session_key!
      @@session_key = nil
    end
    
    def get_video_info(video_id)
      filter = Kaltura::KalturaBaseEntryFilter.new
      filter.id_in = video_id
      
      if @@client.nil?
        self.generate_session_key
      end
      response = @@client.media_service.list(filter)
      if response.total_count == 1
        response.objects.first
      elsif response.total_count == 0
        raise "ID Not found!"
      elsif
        raise "Multiple ID's found!"
      end    
    end
    
  end
end
