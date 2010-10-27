require File.dirname(__FILE__) + '/spec_helper'

include KalturaFu::Entry::Metadata

describe "Actions on an entries metadata" do
  before(:all) do
    KalturaFuTestConfiguration.setup
  end
  
  it "should respond to getting, setting, and adding valid entry attributes" do
    self.should respond_to :get_name
    self.should respond_to :set_description
    self.should respond_to :add_categories
  end
  it "should not respond to getting, setting, and adding invalid entry attributes" do
    self.should_not respond_to :add_waffles
    self.should_not respond_to :set_magic
    self.should_not respond_to :get_barack_obama
  end
end