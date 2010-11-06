module KalturaFu
  module Entry
    module Metadata
      
      ##
      # It is necessary to have the check for valid Kaltura MediaEntry methods available at both
      # the class and instance level, so they are thrown into this module.
      ##
      module ClassAndInstanceMethods
        
        ##
        # Checks if a requested attribute is in fact a valid MediaEntry atrribute.  
        ##
        def valid_entry_attribute?(request_attribute)
          object_methods, media_entry_methods = Object.instance_methods , Kaltura::MediaEntry.instance_methods

          #clean out all the setter methods from the media entry methods
          valid_media_entry_methods = media_entry_methods.map{|m| m unless m =~/^(.*)=/}.compact!

          valid_media_entry_methods -= object_methods
          valid_entry_attributes.include?(request_attribute.to_sym)
        end
        
        ##
        # @private
        ## 
        def valid_entry_attributes
          object_methods, media_entry_methods = Object.instance_methods , Kaltura::MediaEntry.instance_methods

          #clean out all the setter methods from the media entry methods
          valid_media_entry_methods = media_entry_methods.map{|m| m.to_sym unless m =~/^(.*)=/}.compact!

          valid_media_entry_methods -= object_methods
        end
        ##
        # Determines if an attribute is valid in the sense of the add method making sense.  Only 
        # categories and tags are currently considered valid.
        ## 
        def valid_add_attribute?(request_attribute)
          case request_attribute.to_s
            when /^(.*)_(categories|tags)/ 
              return true
            when /^(categories|tags)/
              return true
          else
            return false
          end 
        end
        
      end
      
    end
  end
end