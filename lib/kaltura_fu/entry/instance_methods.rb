module KalturaFu
  module Entry
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
      
      ##
      # Checks each flavor under a Kaltura entry for readiness.  It is possible under v3 of the Kaltura API
      # to receive a 'ready' status for the entry while flavors are still encoding.  Attempting to view the entry
      # with a player will result in a 'Media is converting' error screen.  This prevents that occurance.
      # 
      # @param [String] video_id Kaltura entry_id of the video.
      #
      # @return [Number] Kaltura::Constants::FlavorAssetStatus.  2 is ready.
      ##
      def check_status(entry_id)
         KalturaFu.check_for_client_session

         entry_status = get_status(entry_id)
         if entry_status == Kaltura::Constants::Entry::Status::READY
           flavor_array = KalturaFu.client.flavor_asset_service.get_by_entry_id(entry_id)
           error_count = 0
           not_ready_count = 0
           ready_count = 0
           flavor_array.each do |flavor|
             case flavor.status
               when Kaltura::Constants::FlavorAssetStatus::READY ||  Kaltura::Constants::FlavorAssetStatus::DELETED || Kaltura::Constants::FlavorAssetStatus::NOT_APPLICABLE
                 ready_count +=1
               when Kaltura::Constants::FlavorAssetStatus::ERROR
                 error_count +=1
               when Kaltura::Constants::FlavorAssetStatus::QUEUED || Kaltura::Constants::FlavorAssetStatus::CONVERTING
                 not_ready_count +=1
             end
           end
           #puts "errors: #{error_count} ready:#{ready_count} not_ready:#{not_ready_count} total:#{video_array.size} \n"
           if error_count > 0
             Kaltura::Constants::FlavorAssetStatus::ERROR
           elsif not_ready_count > 0
             Kaltura::Constants::FlavorAssetStatus::CONVERTING
           else
             Kaltura::Constants::FlavorAssetStatus::READY
           end
         else
           entry_status
         end
       end      
      
    end
  end
end