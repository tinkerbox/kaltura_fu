require File.dirname(__FILE__) + '/spec_helper'

describe KalturaFu, :type => :helper do 

  it "should have a javascript include tag" do
    html = helper.include_kaltura_fu
    
    html.should have_tag("script")    
  end

end
