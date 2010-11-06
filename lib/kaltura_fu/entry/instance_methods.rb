module KalturaFu
  module Entry
    ##
    # Instance level methods for the Entry module.
    ##
    module InstanceMethods
      ##
      # Deletes a Kaltura entry.  Unlike the base API delete method, this returns true/false based on success.
      # 
      # @param [String] entry_id Kaltura entry ID to delete.
      #
      # @return [Boolean] returns true if the delete was successful or false otherwise.
      # 
      ##
      def delete_entry(entry_id)
        KalturaFu.check_for_client_session

        begin
          KalturaFu.client.media_service.delete(entry_id)
          true
        rescue Kaltura::APIError => e
          false
        end      
      end     
      
    end
  end
end