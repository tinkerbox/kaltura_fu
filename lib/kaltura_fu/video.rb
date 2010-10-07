module KalturaFu
  ##
  # the Video module provides class methods to retrieve and set information specific to Kaltura Entries.
  # @author Patrick Robertson
  ##
  module Video
    class << self
    
      ##
      # Gets a Kaltura::MediaEntry given a Kaltura entry.
      #
      # @param [String] video_id Kaltura entry_id of the video.
      #
      # @return [Kaltura::MediaEntry] The MediaEntry object for the Kaltura entry.
      ##
      def get_video_info(video_id)  
        self.check_for_client_session
      
        response = self.video_exists?(video_id)
        raise "ID: #{video_id} Not found!" unless response
        response
      end
    
      ##
      # Checks if a Kaltura entry exists.
      # @private
      def video_exists?(video_id)
        self.check_for_client_session
      
        begin
          response = @@client.media_service.get(video_id)
        rescue Kaltura::APIError => e
          response = nil
        end
        if response.nil?
          false
        else
          response
        end
      end
    
      ##
      # Deletes a Kaltura entry.
      # 
      # @param [String] video_id Kaltura entry_id of the video.
      #
      # @return [Boolean] returns true if the delete was successful or false otherwise.
      ##
      def delete_video(video_id)
        self.check_for_client_session
      
        begin
          @@client.media_service.delete(video_id)
          true
        rescue Kaltura::APIError => e
          false
        end
      end
    
      ##
      # Sets the Kaltura entry description metadata.
      #
      # @param [String] video_id Kaltura entry_id of the video.
      # @param [String] description description to add to the Kaltura video.
      #
      # @return [Boolean] returns true if the update was successful or false otherwise.
      ##
      def set_video_description(video_id,description)
        self.check_for_client_session
      
        if self.video_exists?(video_id)
          new_entry = Kaltura::MediaEntry.new
          new_entry.description = description
          @@client.media_service.update(video_id,new_entry)
          true
        else
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
      def check_video_status(video_id)
        self.check_for_client_session
      
        video_array = @@client.flavor_asset_service.get_by_entry_id(video_id)
        status = Kaltura::Constants::FlavorAssetStatus::ERROR
        video_array.each do |video|
          status = video.status
          if video.status != Kaltura::Constants::FlavorAssetStatus::READY
            if video.status == Kaltura::Constants::FlavorAssetStatus::NOT_APPLICABLE
              status = Kaltura::Constants::FlavorAssetStatus::READY
            else
              break
            end
          end
        end
        status
      end
    
      ##
      # Returns a download URL suitable to be used for iTunes one-click syndication.  serveFlavor is not documented in KalturaAPI v3
      # nor is the ?novar=0 paramter.  
      # 
      # @param [String] video_id Kaltura entry_id of the video
      #
      # @return [String] URL that works with RSS/iTunes syndication.  Normal flavor serving is flakey with syndication.
      ##
      def set_syndication_url(video_id)
        self.check_for_client_session
      
        video_array = @@client.flavor_asset_service.get_by_entry_id(video_id)
      
        download_url = nil
        video_array.each do |video|
          if video.is_original
            download_url = 'http://www.kaltura.com/p/203822/sp/20382200/serveFlavor/flavorId/' + video.id.to_s + '/name/' + video.id.to_s + '.' + video.file_ext.to_s + '?novar=0'
          end
        end
        download_url
      end
    
      ##
      # Returns the flavor of the original file uploaded to Kaltura.
      #
      # @param [String] video_id Kaltura entry_id of the video.
      #
      # @return [String] flavor_id
      ##
      def get_original_flavor(video_id)
        self.check_for_client_session
      
        video_array = @@client.flavor_asset_service.get_by_entry_id(video_id)
        ret_flavor = nil
      
        video_array.each do |video|
          if video.is_original
            ret_flavor = video.id.to_s
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
      def get_original_file_extension(video_id)
        self.check_for_client_session
    
        video_array = @@client.flavor_asset_service.get_by_entry_id(video_id)
        source_extension = nil
        video_array.each do |video|
          if video.is_original
            source_extension = video.file_ext
          end
        end
        source_extension
      end
    
      ##
      # Returns the URL of the requested video. 
      # 
      # @param [String] video_id Kaltura entry_id of the video.
      # @param [Number] time optional paramter that will set the thumbnail to a particular second of the video
      # @param [Number] width optional width of the thumbnail.  Defaults to the thumb_width config value.
      # @param [Number] height optional height of the thumbnail.  Defaults to the thumb_height config value.
      # 
      # @return [String] the thumbnail url.
      ##
      def get_thumbnail(video_id,time=nil,width=@@config[:thumb_width],height=@@config[:thumb_height])
        thumbnail_string = "#{@@config[:service_url]}/p/#{@@config[:partner_id]}/thumbnail/entry_id/#{video_id}/width/#{width}/height/#{height}"
        thumbnail_string += "/vid_sec/#{time}" unless time.nil?
        return thumbnail_string
      end
    
    end
  end
end