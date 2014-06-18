require 'spec_helper'

class FlavorSpecTester 
  include KalturaFu::Entry
end

class EntryUploader
  include KalturaFu::Entry
end

describe "Actions specific to an entries flavors" do
  # before(:all) do
  #   KalturaFuTestConfiguration.setup
  # end
  
  # before(:each) do 
  #   @entry_id = EntryUploader.upload(KalturaFuTestConfiguration.video,:source=>:file)
  # end
  
  after(:each) do
    EntryUploader.new.delete_entry(@entry_id)
  end

  it "should return a status of not-ready when a video uploads" do  
    flavor = FlavorSpecTester.new
    flavor.check_status(@entry_id).should_not == Kaltura::Constants::FlavorAssetStatus::READY
  end
  
  it "should respond to original_flavor" do
    flavor = FlavorSpecTester.new
    
    flavor.should respond_to :original_flavor
  end
  
  it "should be able to get the original flavor ID without an error" do
    flavor = FlavorSpecTester.new
    
    lambda{flavor.original_flavor(@entry_id)}.should_not raise_error
  end
  
  it "should respond to original_file_extension" do
    flavor = FlavorSpecTester.new
    
    flavor.should respond_to :original_file_extension
  end
  
  it "should be able to get the original file extension without error" do
    flavor = FlavorSpecTester.new
    
    lambda{flavor.original_file_extension(@entry_id)}.should_not raise_error
  end
  
  it "should have a file extension of FLV for the test video" do
    flavor = FlavorSpecTester.new
    
    extension = nil
    extension = flavor.original_file_extension(@entry_id)
    extension.should == "flv"
  end
  
  it "should respond to original_download_url" do
    flavor = FlavorSpecTester.new
    
    flavor.should respond_to :original_download_url
  end
  
  it "shouldn't blow up when I call original_download_url" do
    flavor = FlavorSpecTester.new
    
    lambda {flavor.original_download_url(@entry_id)}.should_not raise_error
  end
  
  it "original_download_url should look like a reasonable URL" do
    flavor = FlavorSpecTester.new
    
    url = flavor.original_download_url(@entry_id)
    test_url = "#{KalturaFu.config.service_url}/p/#{KalturaFu.config.partner_id}/sp/#{KalturaFu.config.subpartner_id}/serveFlavor/flavorId/#{flavor.original_flavor(@entry_id)}/name/#{flavor.original_flavor(@entry_id)}.#{flavor.original_file_extension(@entry_id)}?novar=0"
    url.should == test_url
  end
  
  it "should respond to changes in service_url" do
    flavor = FlavorSpecTester.new
    old_service_url = KalturaFu.config.service_url
    KalturaFu.config.service_url = "http://www.waffles.com"
    
    url = flavor.original_download_url(@entry_id)
    test_url = "http://www.waffles.com/p/#{KalturaFu.config.partner_id}/sp/#{KalturaFu.config.subpartner_id}/serveFlavor/flavorId/#{flavor.original_flavor(@entry_id)}/name/#{flavor.original_flavor(@entry_id)}.#{flavor.original_file_extension(@entry_id)}?novar=0"
    KalturaFu.config.service_url = old_service_url
    url.should == test_url
  end
end