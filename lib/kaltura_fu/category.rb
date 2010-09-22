module KalturaFu
  class << self
    
    ##
    # Creates a category on the Kaltura server if it doesn't already exist.
    #
    # @param [String] category_name category you wish to add.
    ##
    def create_category(category_name)
      self.check_for_client_session
      
      existing_category = self.category_exists?(category_name)
      unless existing_category
        category = Kaltura::Category.new
        category.name = category_name
        @@client.category_service.add(category)
      else
        existing_category
      end
    end
    
    ##
    # Appends a category to the Kaltura entry.  It is capable of adding the category to the Kaltura server 
    # if it doesn't already exist.  This method will not override existing categories, instead it appends the new
    # category to the end of the list.
    #
    # @param [String] video_id Kaltura entry_id of the video.
    # @param [String] category The category to add to the Kaltura entry.
    # @param [Boolean] force_add true/false flag to force adding the category to the Kaltura server if it doesn't already
    #   exist.  Defaults to false.
    #
    # @return [Kaltura::MediaEntry] Returns the entry updated with the new category appended.
    ##  
    def add_category_to_video(video_id,category,force_add=false)
      self.check_for_client_session
      
      existing_category = category_exists?(category)
      if force_add && !existing_category
        self.create_category(category)
      elsif !force_add && !existing_category
        raise "Category: #{category} does not exist.  Either use the force add flag or manually add the category."
      end
      
      video = self.get_video_info(video_id)
      updated_entry = Kaltura::MediaEntry.new
      if video.categories.nil?
        updated_categories = category
      else
        updated_categories = video.categories + "," + category
      end
      updated_entry.categories = updated_categories
      @@client.media_service.update(video_id,updated_entry)
                
    end
    ##
    # Sets the Kaltura entry metadata to the desired category.  It will overwrite existing categories.
    #
    # @param [String] video_id Kaltura entry_id of the video.
    # @param [String] category The category to add to the Kaltura entry.
    #
    # @return [Boolean] Returns true if the entry was updated, otherwise false.
    ##
    def set_category(video_id,category)
      self.check_for_client_session
      
      if self.video_exists?(video_id)
        updated_entry = Kaltura::MediaEntry.new
        updated_entry.categories = category
        @@client.media_service.update(video_id,updated_entry)
        true
      else
        false
      end
    end
    
    ## 
    # @private
    ##  
    def category_exists?(category_name)
      self.check_for_client_session
      
      category_filter = Kaltura::Filter::CategoryFilter.new
      category_filter.full_name_equal = category_name
      category_check = @@client.category_service.list(category_filter).objects
      if category_check.nil?
        false
      else
        category_check
      end
    end
      
  end
end