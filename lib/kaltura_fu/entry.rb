module KalturaFu
  module Entry

    def delete_entry(entry_id)
      KalturaFu.check_for_client_session
    
      begin
        KalturaFu.client.media_service.delete(video_id)
        true
      rescue Kaltura::APIError => e
        false
      end      
    end

    def self.included(base)
      base.extend ClassMethods
      base.class_eval do 
        include Metadata
      end
      super
    end
    
    module ClassMethods
      def upload
      end
      
      def find
        #pending
      end
    end
  end
end