module KalturaFu
  module Entry
    module Metadata
      
      module ClassAndInstanceMethods
        
        ##
        # Checks if a requested attribute is in fact a valid MediaEntry atrribute.  
        ##
        def valid_entry_attribute?(request_attribute)
          object_methods, media_entry_methods = Object.instance_methods , Kaltura::MediaEntry.instance_methods

          #clean out all the setter methods from the media entry methods
          valid_media_entry_methods = media_entry_methods.map{|m| m unless m =~/^(.*)=/}.compact!

          valid_media_entry_methods -= object_methods
          valid_media_entry_methods.find{|m| m.to_sym == request_attribute.to_sym} ? true : false
        end
         
        ##
        # Determines if an attribute is valid in the sense of the add method making sense.  Only 
        # categories and tags are currently considered valid.
        ## 
        def valid_add_attribute?(request_attribute)
          case request_attribute.to_s
            when /^(.*)_(categor(y|ies)|(tag|tags))/ 
              return true
            when /^(categor(y|ies)|tag)/
              return true
          else
            return false
          end 
        end
        
      end
      
    end
  end
end