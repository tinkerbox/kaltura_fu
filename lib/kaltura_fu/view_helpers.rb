module KalturaFu
  module ViewHelpers
    
    def include_kaltura_fu(*args)
      content = javascript_include_tag('kaltura_upload')
      #content << "\n#{stylesheet_link_tag('')}"                         
    end
    
    #returns a thumbnail image
    def kaltura_thumbnail(entry_id,options={})
      options[:size] ||= []
      size_parameters = ""
      seconds_parameter = ""
      
      unless options[:size].empty?
        size_parameters = "/width/#{options[:size].first}/height/#{options[:size].last}"
      else
        #if the thumbnail width and height are defined in the config, use it, assuming it wasn't locally overriden
        if KalturaFu.config[:thumb_width] && KalturaFu.config[:thumb_height]
          size_parameters = "/width/#{KalturaFu.config[:thumb_width]}/height/#{KalturaFu.config[:thumb_height]}"
        end
      end
      
      unless options[:second].nil?
        seconds_parameter = "/vid_sec/#{options[:second]}"
      end
      
      image_tag("http://www.kaltura.com/p/203822/thumbnail/entry_id/#{entry_id}" + seconds_parameter + size_parameters)
    end
    
    #returns a kaltura player embed object
    def kaltura_player_embed(entry_id,options={})
      player_conf_parameter = ""
      options[:div_id] ||= "kplayer"
      
      unless options[:player_conf_id].nil?
        player_conf_parameter = "/ui_conf_id/#{options[:player_conf_id]}"
      else
        unless KalturaFu.config[:player_conf_id].nil?
          player_conf_parameter = "/ui_conf_id/#{KalturaFu.config[:player_conf_id]}"
        end
      end
      
      "<div id=\"#{options[:div_id]}\"></div>
      <script type=\"text/javascript\">
      	var params= {
      		allowscriptaccess: \"always\",
      		allownetworking: \"all\",
      		allowfullscreen: \"true\",
      		wmode: \"opaque\"
      	};
      	var flashVars = {
      		entryId: \"#{entry_id}\"
      	};

      	swfobject.embedSWF(\"http://www.kaltura.com/kwidget/wid/_#{KalturaFu.config[:partner_id]}" + player_conf_parameter + "\",\"#{options[:div_id]}\",\"400\",\"330\",\"9.0.0\",false,flashVars,params);
      </script>"
    end
    
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
    			partnerId: \"#{KalturaFu.config[:partner_id]}\",
    			subPId: \"#{KalturaFu.config[:subpartner_id]}\",
    			entryId: \"-1\",
    			ks: \"#{KalturaFu.session_key}\",
    			uiConfId: '1103',
    			jsDelegate: \"delegate\"
    		};

        swfobject.embedSWF(\"http://www.kaltura.com/kupload/ui_conf_id/1103\", \"uploader\", \"200\", \"30\", \"9.0.0\", \"expressInstall.swf\", flashVars, params,attributes);

    	</script>"
    end
  end
end