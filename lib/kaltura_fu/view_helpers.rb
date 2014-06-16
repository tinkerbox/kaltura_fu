module KalturaFu
  
  ##
  # The ViewHelpers module provides extensions to Rails ActionView class that allow interactions with Kaltura on rails view layer.
  # 
  # @author Patrick Robertson
  ##
  module ViewHelpers
    # default UI Conf ID of the kdp player
    DEFAULT_KPLAYER = '1339442'
    # default embedded KDP width
    PLAYER_WIDTH = '400'
    # default embedded KDP height
    PLAYER_HEIGHT = '330'
    
    ##
    # Convienence to include SWFObject and the required Kaltura upload embed javascripts.
    ##
    def include_kaltura_fu(*args)
      content = javascript_include_tag('kaltura_upload')
      content << "\n#{javascript_include_tag('http://ajax.googleapis.com' + 
		 '/ajax/libs/swfobject/2.2/swfobject.js')}" 
    end
    
    ##
    # Returns the thumbnail of the provided Kaltura Entry.
    # @param [String] entry_id Kaltura entry_id
    # @param [Hash] options the options for the thumbnail parameters.
    # @option options [Array] :size ([]) an array of [width,height]
    # @option options [String] :second (nil) the second of the Kaltura entry that the thumbnail should be of.
    # 
    # @return [String] Image tag of the thumbnail resource.
    ##
    def kaltura_thumbnail(entry_id,options={})
      options[:size] ||= []
      size_parameters = ""
      seconds_parameter = ""
      
      unless options[:size].empty?
        size_parameters = "/width/#{options[:size].first}/height/" +
			  "#{options[:size].last}"
      else
        # if the thumbnail width and height are defined in the config,
	      # use it, assuming it wasn't locally overriden
        if KalturaFu.config[:thumb_width] && KalturaFu.config[:thumb_height]
          size_parameters = "/width/#{KalturaFu.config[:thumb_width]}/height/" +
			    "#{KalturaFu.config[:thumb_height]}"
        end
      end
      
      unless options[:second].nil?
        seconds_parameter = "/vid_sec/#{options[:second]}"
      else
        seconds_parameter = "/vid_sec/5"
      end
      
      image_tag("#{KalturaFu.config[:service_url]}/p/#{KalturaFu.config[:partner_id]}" +
		"/thumbnail/entry_id/#{entry_id}" + 
		seconds_parameter + 
		size_parameters)
    end
    
    ##
    # Returns the code needed to embed a KDPv3 player.
    #
    # @param [String] entry_id Kaltura entry_id
    # @param [Hash] options the embed code options.
    # @option options [String] :div_id ('kplayer') The div element that the flash object will be inserted into.
    # @option options [Array] :size ([]) The [width,wight] of the player.
    # @option options [Boolean] :use_url (false) flag to determine whether entry_id is an entry or a URL of a flash file.
    # @option options [String] :player_conf_id (KalturaFu.config(:player_conf_id)) A UI Conf ID to override the player with.
    #
    # @return [String] returns a string representation of the html/javascript necessary to play a Kaltura entry.
    ##
    def kaltura_player_embed(entry_id,options={})
      player_conf_parameter = "/ui_conf_id/"
      options[:div_id] ||= "kplayer"
      options[:size] ||= []
      options[:use_url] ||= false
      width = PLAYER_WIDTH
      height = PLAYER_HEIGHT
      source_type = "entryId"

      unless options[:size].empty?
	      width = options[:size].first
	      height = options[:size].last
      end
        
      if options[:use_url] == true
        source_type = "url"
      end
    
      unless options[:player_conf_id].nil?
        player_conf_parameter += "#{options[:player_conf_id]}"
      else
        unless KalturaFu.config.player_conf_id.nil?
          player_conf_parameter += "#{KalturaFu.config.player_conf_id}"
	      else
	        player_conf_parameter += "#{DEFAULT_KPLAYER}"
        end
      end
      
      "<div id=\"#{options[:div_id]}\"></div>
      <script type=\"text/javascript\">
      	var params= {
      		allowscriptaccess: \"always\",
      		allownetworking: \"all\",
      		allowfullscreen: \"true\",
      		wmode: \"opaque\",
      		bgcolor: \"#000000\"
      	};
      	var flashVars = {};
      	flashVars.sourceType = \"#{source_type}\";      	  
      	flashVars.entryId = \"#{entry_id}\";
      	flashVars.emptyF = \"onKdpEmpty\";
    		flashVars.readyF = \"onKdpReady\";
      		
      	var attributes = {
          id: \"#{options[:div_id]}\",
          name: \"#{options[:div_id]}\"
      	};

      	swfobject.embedSWF(\"#{KalturaFu.config.service_url}/kwidget/wid/_#{KalturaFu.config.partner_id}" + player_conf_parameter + "\",\"#{options[:div_id]}\",\"#{width}\",\"#{height}\",\"10.0.0\",\"http://ttv.mit.edu/swfs/expressinstall.swf\",flashVars,params,attributes);
      </script>"
    end
    
    ##
    # Returns the html/javascript necessary for a KSU widget.
    #
    # @param [Hash] options 
    # @option options [String] :div_id ('uploader') div that the flash object will be inserted into.
    ##
    def kaltura_upload_embed(options={})
      options[:div_id] ||="uploader"
      "<div id=\"#{options[:div_id]}\"></div>
    		<script type=\"text/javascript\">

    		var params = {
    			allowScriptAccess: \"always\",
    			allowNetworking: \"all\",
    			wmode: \"transparent\"
    		};
    		var attributes = {
    			id: \"uploader\",
    			name: \"KUpload\"
    		};
    		var flashVars = {
    			uid: \"ANONYMOUS\",
    			partnerId: \"#{KalturaFu.config.partner_id}\",
    			subPId: \"#{KalturaFu.config.partner_id}00\",
    			entryId: \"-1\",
    			ks: \"#{KalturaFu::Session.session_key}\",
    			uiConfId: '4211621',
    			jsDelegate: \"delegate\",
    			maxFileSize: \"999999999\",
    			maxTotalSize: \"999999999\"
    		};

        swfobject.embedSWF(\"#{KalturaFu.config.service_url}/kupload/ui_conf_id/4211621\", \"uploader\", \"160\", \"26\", \"9.0.0\", \"expressInstall.swf\", flashVars, params,attributes);

    	</script>"
    end
    
    ##
    # Creates a link_to tag that seeks to a certain time on a KDPv3 player.
    #
    # @param [String] content The text in the link tag.
    # @param [Integer] seek_time The time in seconds to seek the player to.
    # @param [Hash] options
    #
    # @option options [String] :div_id ('kplayer') The div of the KDP player.
    ##
    def kaltura_seek_link(content,seek_time,options={})
      options[:div_id] ||= "kplayer"

      options[:onclick] = "$(#{options[:div_id]}).get(0).sendNotification('doSeek',#{seek_time});window.scrollTo(0,0);return false;"
      options.delete(:div_id)
      link_to(content,"#", options)
    end
  end
  
  
end
