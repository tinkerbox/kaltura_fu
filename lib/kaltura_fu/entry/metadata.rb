module KalturaFu
  module Entry
    module Metadata
      
      def method_missing(name, *args)
        case name.to_s
          when /^set_(.*)/
            valid_entry_attribute?($1.to_sym) ? get_entry(*args) : super
          when /^add_(.*)/
            valid_entry_attribute?($1.to_sym) ? get_entry(*args) : super
          when /^get_(.*)/
            valid_entry_attribute?($1.to_sym) ? get_entry(*args).send($1.to_sym) : super
        else
          super
        end
      end
      
      def respond_to?(method)
        case method.to_s
          when /^(get|set|add)_(.*)/
            valid_entry_attribute?($2.to_sym) || super
        else
          super
        end         
      end
      
      def valid_entry_attribute?(request_attribute)
        object_methods, media_entry_methods = Object.new.methods , Kaltura::MediaEntry.new.methods

        #clean out all the setter methods from the media entry methods
        valid_media_entry_methods = media_entry_methods.map{|m| m unless m =~/^(.*)=/}.compact!

        valid_media_entry_methods -= object_methods
        valid_media_entry_methods.find{|m| m.to_sym == request_attribute.to_sym} ? true : false
      end
      
      ##
      # Gets a Kaltura::MediaEntry given a Kaltura entry.
      #
      # @param [String] video_id Kaltura entry_id of the video.
      #
      # @return [Kaltura::MediaEntry] The MediaEntry object for the Kaltura entry.
      # @raose [Kaltura::APIError] Raises a kaltura error if it can't find the entry.
      ##
      def get_entry(video_id)  
        KalturaFu.check_for_client_session

        KalturaFu.client.media_service.get(video_id)      
      end
      
    end
  end
end