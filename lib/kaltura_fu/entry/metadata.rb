require 'active_support'

module KalturaFu
  module Entry
    module Metadata

      ##
      # @private
      ##
      def self.included(base)
        base.extend ClassAndInstanceMethods
        base.class_eval do
          include ClassAndInstanceMethods
        end
        super
      end
      
      ##
      # @private
      ##      
      def method_missing(name, *args)
        case name.to_s
          when /^set_(.*)/
            valid_entry_attribute?($1.to_sym) ? set_attribute($1,*args) : super
          when /^add_(.*)/
            valid_entry_attribute?($1.pluralize.to_sym) ? add_attribute($1.pluralize,*args) : super
          when /^get_(.*)/
            valid_entry_attribute?($1.to_sym) ? get_entry(*args).send($1.to_sym) : super
        else
          super
        end
      end
      
      ##
      # @private
      ##
      def respond_to?(method)
        case method.to_s
          when /^(get|set)_(.*)/
            valid_entry_attribute?($2.to_sym) || super
          when /^(add)_(.*)/
            (valid_entry_attribute?($2.pluralize.to_sym) && valid_add_attribute?($2) ) || super
        else
          super
        end         
      end
      
      ##
      # Gets a Kaltura::MediaEntry given a Kaltura entry.
      #
      # @param [String] video_id Kaltura entry_id of the video.
      #
      # @return [Kaltura::MediaEntry] The MediaEntry object for the Kaltura entry.
      # @raose [Kaltura::APIError] Raises a kaltura error if it can't find the entry.
      ##
      def get_entry(entry_id)  
        KalturaFu.check_for_client_session

        KalturaFu.client.media_service.get(entry_id)      
      end
      
      ##
      # Sets a specific Kaltura::MediaEntry attribute given a Kaltura entry.
      # This method is called by method_missing, allowing this module set attributes based
      # off of the current API wrapper, rather than having to update along side the API wrapper.
      #
      # @param [String] attr_name The attribute to set.
      # @param [String] entry_id The Kaltura entry ID.
      # @param [String] value The value you wish to set the attribute to.
      # 
      # @return [String] Returns the value as stored in the Kaltura database.  Tag strings come back
      #   slightly funny.
      #
      # @raise [Kaltura::APIError] Passes Kaltura API errors directly through.
      ##
      def set_attribute(attr_name,entry_id,value)
        KalturaFu.check_for_client_session
        
        add_categories_to_kaltura(value) if (attr_name =~ /^(.*)_categories/ || attr_name =~ /^categories/)
        
        media_entry = Kaltura::MediaEntry.new
        media_entry.send("#{attr_name}=",value)
        KalturaFu.client.media_service.update(entry_id,media_entry).send(attr_name.to_sym)
        
      end
      
      ##
      # @private
      ##
      def add_categories_to_kaltura(categories)
        KalturaFu.check_for_client_session
        
        categories.split(",").each do |category|
          unless category_exists?(category)
            cat = Kaltura::Category.new
            cat.name = category
            KalturaFu.client.category_service.add(cat)            
          end
        end
      end
      
      ## 
      # @private
      ##  
      def category_exists?(category_name)
        KalturaFu.check_for_client_session

        category_filter = Kaltura::Filter::CategoryFilter.new
        category_filter.full_name_equal = category_name
        category_check = KalturaFu.client.category_service.list(category_filter).objects
        if category_check.nil?
          false
        else
          category_check
        end
      end
      
      
      ##
      # Appends a specific Kaltura::MediaEntry attribute to the end of the original attribute given a Kaltura entry.
      # This method is called by method_missing, allowing this module add attributes based
      # off of the current API wrapper, rather than having to update along side the API wrapper.
      #
      # @param [String] attr_name The attribute to set.
      # @param [String] entry_id The Kaltura entry ID.
      # @param [String] value The value you wish to append the attribute with.
      # 
      # @return [String] Returns the value as stored in the Kaltura database.  Tag strings come back
      #   slightly funny.
      #
      # @raise [Kaltura::APIError] Passes Kaltura API errors directly through.
      ##      
      def add_attribute(attr_name,entry_id,value)
        KalturaFu.check_for_client_session


        add_categories_to_kaltura(value) if (attr_name =~ /^(.*)_categor(ies|y)/ || attr_name =~ /^categor(ies|y)/)        
        
        old_attributes = KalturaFu.client.media_service.get(entry_id).send(attr_name.to_sym)
        media_entry = Kaltura::MediaEntry.new
        media_entry.send("#{attr_name}=","#{old_attributes},#{value}")
        KalturaFu.client.media_service.update(entry_id,media_entry).send(attr_name.to_sym)
      end
      
    end
  end
end