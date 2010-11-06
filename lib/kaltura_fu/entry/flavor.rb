module KalturaFu
  module Entry
    module Flavor
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
    
      ##
      # Returns the flavor ID of the original file uploaded to Kaltura.
      #
      # @param [String] video_id Kaltura entry_id of the video.
      #
      # @return [String] flavor_id
      ##
      def original_flavor(entry_id)
       KalturaFu.check_for_client_session

       flavor_array = KalturaFu.client.flavor_asset_service.get_by_entry_id(entry_id)
       ret_flavor = nil

       flavor_array.each do |flavor|
         if flavor.is_original
           ret_flavor = flavor.id.to_s
           break
         end
       end
       ret_flavor
      end

      ##
      # Returns the file extension of the original file uploaded to Kaltura for a given entry
      #
      # @param [String] video_id Kaltura entry_id of the video.
      #
      # @return [String] file extension
      ##
      def original_file_extension(entry_id)
        KalturaFu.check_for_client_session

        flavor_array = KalturaFu.client.flavor_asset_service.get_by_entry_id(entry_id)
        source_extension = nil
        flavor_array.each do |flavor|
          if flavor.is_original
            source_extension = flavor.file_ext
            break
          end
        end
        source_extension
      end
             
    end
  end
end