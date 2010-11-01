require File.dirname(__FILE__) + '/spec_helper'

class EntrySpecTester
  include KalturaFu::Entry
end

describe "Kaltura Fu's Entry Class Methods" do
  before(:all) do
    KalturaFuTestConfiguration.setup
    @tester = EntrySpecTester.new
  end
  
  it "Responds to upload" do
    EntrySpecTester.should respond_to :upload
  end
  
  it "Allows a valid file to be uploaded and deleted" do
    entry_id = nil
    lambda {entry_id = EntrySpecTester.upload(KalturaFuTestConfiguration.video, :source=>:file)}.should_not raise_error
    
    lambda {@tester.get_entry(entry_id)}.should_not raise_error
    check = @tester.delete_entry(entry_id)
    check.should be_true
  end
  
  it "Does nothing when you don't source the method as a file upload" do
    entry_id = nil
    lambda {entry_id = EntrySpecTester.upload("waffles",:source=>:url)}.should_not raise_error
    entry_id.should be_nil
  end
  
  it "Handles valid Media Entry attributes when you provide them in the options hash" do
    video_options = {}
    video_options[:name] = "My fantastic movie."
    video_options[:description] = "A movie of unparralled awesomeness."
    video_options[:tags] = "man, this, is, awesome"
    video_options[:source] = :file
    
    entry_id = nil
    lambda {entry_id = EntrySpecTester.upload(KalturaFuTestConfiguration.video,video_options)}.should_not raise_error
    
    media_entry = nil
    lambda {media_entry = @tester.get_entry(entry_id)}.should_not raise_error
    media_entry.name.should == video_options[:name]
    media_entry.description.should == video_options[:description]
    media_entry.tags.should == video_options[:tags]
    
    check = @tester.delete_entry(entry_id)
    check.should be_true
  end
  
  it "Is totally cool with you supplying jibberish in the options too." do
    video_options = {}
    video_options[:name] = "My fantastic movie."
    video_options[:description] = "A movie of unparralled awesomeness."
    video_options[:tags] = "man, this, is, awesome"
    video_options[:source] = :file
    video_options[:waffles] = "WHATEVER WAFFLES"
    
    entry_id = nil
    lambda {entry_id = EntrySpecTester.upload(KalturaFuTestConfiguration.video,video_options)}.should_not raise_error
    
    media_entry = nil
    lambda {media_entry = @tester.get_entry(entry_id)}.should_not raise_error
    media_entry.name.should == video_options[:name]
    media_entry.description.should == video_options[:description]
    media_entry.tags.should == video_options[:tags]
    media_entry.should_not respond_to :waffles
    
    check = @tester.delete_entry(entry_id)
    check.should be_true    
  end
end