require File.dirname(__FILE__) + '/spec_helper'

describe "General Configuration testing" do
  it "Should start with an empty config" do
    KalturaFu.config.should be_empty
  end
  
  it "Shouldn't generate a Kaltura session on an empty config" do
    lambda {KalturaFu.generate_session_key}.should raise_error(RuntimeError, "Missing Partner Identifier")
  end
  
  it "Shouldn't generate a Kaltura session without an administrator secret" do
    KalturaFu.config[:partner_id] = '121413'
    lambda {KalturaFu.generate_session_key}.should raise_error(RuntimeError, "Missing Administrator Secret")
  end
  
  it "Should respect the Service URL when constructing a Client configuration" do
    KalturaFu.config[:parnter_id] = '123434'
    lambda {KalturaFu.create_client_config}.should_not raise_error
    
    KalturaFu.client_configuration.service_url.should == "http://www.kaltura.com"
    
    service_url = "http://www.waffletastic.com"
    KalturaFu.config[:service_url] = service_url
    KalturaFu.create_client_config
    KalturaFu.client_configuration.service_url.should == service_url
  end
  
  it "Should raise a Kaltura::APIError when you provide incorrect information." do
    KalturaFu.config = {}
    KalturaFu.config[:partner_id] , KalturaFu.config[:administrator_secret] = '1241' , 'a3$35casd'
    lambda {KalturaFu.generate_session_key}.should raise_error(Kaltura::APIError)
  end
end
describe "Valid Configuration tests" do
  before :each do 
    KalturaFuTestConfiguration.setup
  end
  
  it "Should function just fine with proper credentials" do
    lambda {KalturaFu.generate_session_key}.should_not raise_error
  end
  
  it "Should allow you to clear the session" do
    KalturaFu.generate_session_key
    KalturaFu.clear_session_key!
    
    KalturaFu.session_key.should be nil
  end
  
  it "Should generate a valid session if you ask politely" do
    KalturaFu.clear_session_key!
    KalturaFu.check_for_client_session
    
    KalturaFu.session_key.should_not be nil
  end
end