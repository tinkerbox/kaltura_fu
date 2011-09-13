require 'kaltura_fu/entry/metadata'
require 'kaltura_fu/entry/class_methods'
require 'kaltura_fu/entry/instance_methods'
require 'kaltura_fu/entry/flavor'

module KalturaFu
  
  ##
  # The entry module provides a slightly more intuitive interface to the
  # Kaltura media service.  It determines what retrieval and setting actions 
  # you can perform based upon the version of the Kaltura-Ruby library using 
  # reflection.  This allows Kaltura_Fu to be a bit more future proof than the 
  # Kaltura API client itself!   The tradeoff is that getting/adding/setting 
  # attributes are defined dynamically.  The current behavior is that the first
  # call to a dynamic method will then define all of Kaltura's media entries 
  # methods.  This allows the module to be slightly lighter weight in the event
  # that it is included in a class but never used, and faster than using method_missing
  # lookups for 100% of the dynamic methods.  The first call will be slower though,
  # as it generates numerous other methods.
  # 
  # == Usage
  # The entry module is intended to be used to link Rails Models to Kaltura MediaEntry's.  
  # However, you should not perform these actions during a web application request.  Doing
  # so will slow down your request unecessarily.  There is nearly nothing gained from adding a
  # round trip to your Kaltura server to make an update synchronus.  Instead, this module
  # should mostly be used in processing a background request from an observer.  
  #
  # == Uploading to Kaltura
  # The entry module provides convienance to uploading directly to your installation of 
  # Kaltura.  For your web application, there are two Kaltura flash widgets that perform
  # a much better job of uploading files though.  This functionality has been used in 
  # production environments that use lecture capture.  A video file is placed in a folder, 
  # a script picks the file up, and then uploads it into Kaltura.
  #
  # The Kaltura API supports uploading media from files, URL's, and also has a batch action.  
  # The implementation of Kaltura Fu currently ignores the URL and batch methods, instead 
  # focusing on file uploading.
  #
  # @example A basic file upload example:
  #   media_file = File.new("/path/to/video.mp4")
  #   upload(media_file,:source => :file)
  #
  # @example A file upload with metadata fields populated:
  #   media_file = File.new("/path/to/video.mp4")
  #   upload(media_file, :source => :file,
  #     :name => "My Rad video",
  #     :description => "I'm capable of such rad things.",
  #     :tags => "rad,rowdy,video,h.264",
  #     :categories => "raditude"
  #   )
  # == Getting, Setting, and Adding Metadata
  # The entry module provides an easy mean to retrieve the current state and modify a Kaltura entry.
  # For metadata fields that act as a list of objects, it also provides an easy way to append values
  # onto the list.  It uses get_ and set_ instead of the more common Ruby practice of using just the 
  # attribute and attribute= so that you can include this module in your model without conflict.  Also,
  # when you are performing actions on the category fields, the module is making sure these are available
  # in the KMC by calling Kaltura's Category service.
  # 
  # @example Retrieving metadata:
  #   get_name("1_q34aa52a")
  #   get_categories("1_q34aa52a")
  #
  # @example Setting metadata:
  #   set_name("1_q34aa52a", "waffles")
  #   set_categories("1_q34aa52a", "HD,h.264,live recording")
  #
  # @example Appending tags to an existing set:
  #   add_tags("1_q34aa52a","eductation, lecture capture")
  # 
  # == Checking the Status of an Entry
  # One unfortunate aspect of the Kaltura API is that an entry will report it's status as "ready"
  # while flavors are still encoding.  When you embed the entry on a webpage, it will render an
  # error "Media is currently converting".  The only solution is to instead check the status of 
  # each flavor instead to ensure total readiness.
  #
  # @example Checking an entries status:
  #   check_status("1_q34aa52a")
  #
  # == Retrieving Status About the Source Video
  # Occasionally, you need to interact with the original video in some form or another with Kaltura.
  # One production situation I have encountered in the past is maintaining a copy of the source video
  # on a large data store seperate from Kaltura.  It is extremely difficult to work with the download
  # URL that Kaltura provides for that.
  #
  # @example Getting the Flavor ID of the original video associated with an entry:
  #   original_flavor("1_q34aa52a")
  #
  # @example Getting the file extension of the original video associated with an entry:
  #   original_file_extension("1_q34aa52a")
  # 
  # @example Getting a usable download URL for the entries original file:
  #   original_download_url("1_q34aa52a")
  #
  # @author Patrick Robertson
  ##
  module Entry
        
    ##
    # @private
    ##
    def self.included(base)
      base.extend ClassMethods
      base.class_eval do 
        include Metadata
        include InstanceMethods
        include Flavor
      end
      super
    end
    
  end #Entry
end #KalturFu