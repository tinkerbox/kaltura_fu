require File.dirname(__FILE__) + '/spec_helper'

describe KalturaFu, :type => :helper do 

  it "should have a javascript include tag" do
    html = helper.include_kaltura_fu
    
    html.should have_tag("script[src= ?]", "http://ajax.googleapis.com/ajax/libs/swfobject/2.2/swfobject.js" )

    html.should have_tag("script[src like ?]","/javascripts/kaltura_upload.js?*")    
  end

end
