require 'spec_helper'

class FlavorSpecTester 
  include KalturaFu::Entry
end

class EntryUploader
  include KalturaFu::Entry
end

describe "Actions specific to an entries flavors" do
  before(:all) do
    KalturaFuTestConfiguration.setup
  end
  
  before(:each) do 
    @entry_id = EntryUploader.upload(KalturaFuTestConfiguration.video,:source=>:file)
  end
  
  after(:each) do
    EntryUploader.new.delete_entry(@entry_id)
  end

  it "should return a status of not-ready when a video uploads" do  
    flavor = FlavorSpecTester.new
    flavor.check_status(@entry_id).should_not == Kaltura::Constants::FlavorAssetStatus::READY
  end
end