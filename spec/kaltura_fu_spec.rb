require File.dirname(__FILE__) + '/spec_helper'

describe KalturaFu, :type => :helper do 

  it "should have the proper javascript include tags" do
    html = helper.include_kaltura_fu
    
    html.should have_tag("script[src= ?]", "http://ajax.googleapis.com/ajax/libs/swfobject/2.2/swfobject.js" )

    html.should have_tag("script[src = ?]",%r{/javascripts/kaltura_upload.js\?[0-9]*})    
  end

  it "should create a plain thumbnail" do
    html = helper.kaltura_thumbnail(12345)


    if KalturaFu.config[:thumb_width] && KalturaFu.config[:thumb_height]
      html.should have_tag("img[src = ?]" ,
			   "http://www.kaltura.com/p/" + KalturaFu.config[:partner_id]				 + "/thumbnail/entry_id/12345" + 
			   "/width/" + KalturaFu.config[:thumb_width] + 
			   "/height/" + KalturaFu.config[:thumb_height])
    else
      html.should have_tag("img[src = ?]", 
			   "http://www.kaltura.com/p/" + KalturaFu.config[:partner_id]
			   + "/thumbnail/entry_id/12345"
    end
  end

end
