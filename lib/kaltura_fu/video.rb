module KalturaFu
  ##
  # the Video module provides class methods to retrieve and set information specific to Kaltura Entries.
  # @author Patrick Robertson
  ##
  module Video

    ##
    # Returns the flavor of the original file uploaded to Kaltura.
    #
    # @param [String] video_id Kaltura entry_id of the video.
    #
    # @return [String] flavor_id
    ##
    def get_original_flavor(video_id)
      KalturaFu.check_for_client_session
    
      video_array = KalturaFu.client.flavor_asset_service.get_by_entry_id(video_id)
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
      KalturaFu.check_for_client_session
  
      video_array = KalturaFu.client.flavor_asset_service.get_by_entry_id(video_id)
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
      config = KalturaFu.config
      
      thumbnail_string = "#{config[:service_url]}/p/#{config[:partner_id]}/thumbnail/entry_id/#{video_id}/width/#{width}/height/#{height}"
      thumbnail_string += "/vid_sec/#{time}" unless time.nil?
      return thumbnail_string
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
      KalturaFu.check_for_client_session
    
      video_array = KalturaFu.client.flavor_asset_service.get_by_entry_id(video_id)
    
      download_url = nil
      video_array.each do |video|
        if video.is_original
          download_url = 'http://www.kaltura.com/p/203822/sp/20382200/serveFlavor/flavorId/' + video.id.to_s + '/name/' + video.id.to_s + '.' + video.file_ext.to_s + '?novar=0'
        end
      end
      download_url
    end
    
  end
end