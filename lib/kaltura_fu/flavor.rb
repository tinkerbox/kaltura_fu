module KalturaFu
  ##
  # The Flavor module provides interactions for adding and removing specific encodings from a Kaltura entry.
  ##
  module Flavor
    
    ##
    # Adds a specific encoding profile to a Kaltura entry.
    #
    # @param [String] video_id The Kaltura media entry.
    # @param [Integer] flavor_param_id The ID of the FlavorParam (individual encoding profile) to use.
    # 
    # @return [nil] Returns nothing.
    #
    # @raie [RuntimeError] Raises a runtime error if the video_id doesn't exist.
    #
    # @since 0.1.3
    #
    # @todo Make this method return something.
    ##
    def add_flavor_to_video(video_id,flavor_param_id)
      self.check_for_client_session
      
      if video_exists?(video_id)
        @@client.flavor_asset_service.convert(video_id,flavor_param_id)
      end
    end
    
    ##
    # Finds a specific flavor object given a Kaltura entry and FlavorParam.  This is useful if you want to
    # delete a specific type of encoding from a Video programatically.
    #
    # @param [String] video_id The Kaltura media entry.
    # @param [Integer] flavor_param_id The ID of the FlavorParam (individual encoding profile) to use.
    #
    # @return [Kaltura::FlavorAsset] Returns the requested FlavorAsset.
    #
    # @raise [RuntimeError] Raises a runtime error if the video_id doesn't exist.
    #
    # @since 0.1.3
    # 
    # @todo Ensure a graceful error when the FlavorAsset isn't found as well.
    ##
    def find_flavor_from_entry(video_id,flavor_param_id)
      self.check_for_client_session
      return_flavor = nil
      
      if video_exists?(video_id)
        flavor_array = @@client.flavor_asset_service.get_flavor_assets_with_params(video_id)
        flavor_array.each do |flavor_object|
          if flavor_object.flavor_params.id == flavor_param_id
            return_flavor = flavor_object.flavor_asset.id
          end
        end
      end
    end
    
    ##
    # Removes either a specific flavor asset.  If you know the exact Flavor you wish to delete
    #   you can specify it.  Otherwise, you can specify the videos entry_id and a specific 
    #   FlavorParam (encoding profile) and it will locate and remove the Flavor for you.
    #
    # @param [String] entry_or_flavor The Kaltura entry_id or the FlavorAsset ID.
    # @param [Integer] flavor_param_id An optional flavorParam encoding profile to seek.
    #
    # @return [Boolean] Returns true if the removal was succesful.  
    #
    # @raise [RuntimeError] Raises a runtime error if the video's entry_id doesn't exist.
    #
    # @since 0.1.3
    #
    # @todo Ensure that a missing FlavorParam or FlavorAsset doesn't cause unexpected behavior.
    ##
    def remove_flavor_from_video(entry_or_flavor, flavor_param_id=nil)
      self.check_for_client_session
      ret_val = false
      
      if flavor_param_id.nil?
        @@client.flavor_asset_service.delete(entry_or_flavor)
        ret_val = true
      else
        flavor_to_delete = self.find_flavor_from_entry(entry_or_flavor,flavor_param_id)
        self.remove_flavor_from_video(flavor_to_delete)
      end
      ret_val
    end
    
  end
end