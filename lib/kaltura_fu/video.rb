module KalturaFu
  ##
  # the Video module provides class methods to retrieve and set information specific to Kaltura Entries.
  # @author Patrick Robertson
  ##
  module Video


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
    
  end
end