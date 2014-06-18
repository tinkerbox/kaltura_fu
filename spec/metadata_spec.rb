require 'spec_helper'

class MetadataSpecTester 
  include KalturaFu::Entry::Metadata
end

class EntryUploader
  include KalturaFu::Entry
end

describe "Actions on an entries metadata" do
  # before(:all) do
  #   KalturaFuTestConfiguration.setup
  # end
  
  # before(:each) do 
  #   @entry_id = EntryUploader.upload(KalturaFuTestConfiguration.video,:source=>:file)
  # end
  
  after(:each) do
    EntryUploader.new.delete_entry(@entry_id)
  end
  
  it "should respond to getting valid entry attributes" do
    test = MetadataSpecTester.new
    test.should respond_to :get_name
  end
  
  it "should respond to getting valid entry attributes" do
    test = MetadataSpecTester.new
    test.should respond_to :get_description
  end
  
  it "should respond to getting valid entry attributes" do
    test = MetadataSpecTester.new
    test.should respond_to :get_categories
  end
  
  it "should respond to setting valid entry attributes" do
    test = MetadataSpecTester.new
    test.should respond_to :set_description
  end
  
  it "should respond to setting valid entry attributes" do
    test = MetadataSpecTester.new
    test.should respond_to :set_name
  end
  
  it "should respond to setting valid entry attributes" do
    test = MetadataSpecTester.new
    test.should respond_to :set_categories
  end
    
  it "should respond to adding valid entry attributes" do
    test = MetadataSpecTester.new
    test.should respond_to :add_categories
  end
  
  it "should respond to adding valid entry attributes" do
    test = MetadataSpecTester.new
    test.should respond_to :add_tags
  end
    
  it "should respond to adding valid entry attributes" do
    test = MetadataSpecTester.new
    test.should respond_to :add_admin_tags
  end
  
  it "should not respond to getting invalid entry attributes" do
    test = MetadataSpecTester.new
    test.should_not respond_to :get_barack_obama
  end
  
  it "should not respond to setting invalid entry attributes" do
    test = MetadataSpecTester.new
    test.should_not respond_to :set_magic
  end
  
  it "should not respond to adding invalid entry attributes" do
    test = MetadataSpecTester.new
    test.should_not respond_to :add_waffles
  end  
  
  it "should not respond to adding invalid entry attributes" do
    test = MetadataSpecTester.new
    test.should_not respond_to :add_category
  end
  
  it "should not respond to adding invalid entry attributes" do
    test = MetadataSpecTester.new
    test.should_not respond_to :add_tag
  end  
  
  it "should not respond to adding invalid entry attributes" do
    test = MetadataSpecTester.new
    test.should_not respond_to :add_admin_tag
  end  
  
  it "should not respond to adding valid entry attributes, but improperly typed" do
    test = MetadataSpecTester.new
    test.should_not respond_to :add_name
  end
  
  it "should not respond to adding valid entry attributes, but improperly typed" do
    test = MetadataSpecTester.new
    test.should_not respond_to :add_names
  end
  
  it "should set the name field when asked kindly" do
    test = MetadataSpecTester.new    
    test.set_name(@entry_id,"waffles").should == "waffles"
  end
  
  it "should set the desription field when asked kindly" do
    test = MetadataSpecTester.new    
    test.set_description(@entry_id,"The beginning of the end of the beginning").should == "The beginning of the end of the beginning"
  end
  
  it "should be a little weirder when setting a group of tags" do
    test = MetadataSpecTester.new
    test.set_tags(@entry_id,"waffles,awesome,rock,hard").should == "waffles, awesome, rock, hard"
    test.get_tags(@entry_id).should == "waffles, awesome, rock, hard"
  end
  
  it "should just be weird with tags, admin tags don't act this way either" do
    test = MetadataSpecTester.new
    test.set_admin_tags(@entry_id,"waffles,awesome,rock,hard").should == "waffles,awesome,rock,hard"
    test.get_admin_tags(@entry_id).should == "waffles,awesome,rock,hard"
  end  
  
  it "shouldn't act like tags with categories" do
    test = MetadataSpecTester.new
    test.set_categories(@entry_id,"waffles,awesome,rock,hard").should == "waffles,awesome,rock,hard"
  end
  
  it "should raise a Kaltura::APIError when you give it a bogus entry" do
    test = MetadataSpecTester.new
    
    lambda {test.set_name("waffles","waffles")}.should raise_error(Kaltura::APIError)
  end
  
  it "should not increment the version when you perform set actions" do
    test = MetadataSpecTester.new
    
    version_count = test.get_version(@entry_id).to_i
    
    test.set_name(@entry_id,"my new name")
    test.get_version(@entry_id).to_i.should == version_count
  end
  
  it "should not increment the version when you perform set actions on tags" do
    test = MetadataSpecTester.new
    
    version_count = test.get_version(@entry_id).to_i
    
    test.set_tags(@entry_id,"buttons,kittens,pirates")
    test.get_version(@entry_id).to_i.should == version_count
  end
  
  it "should be making KMC categories for every category you set unless it already exists." do
    test = MetadataSpecTester.new
    
    categories = "waffles#{rand(10)},pirates#{rand(18)},peanuts#{rand(44)}"
    categories.split(",").each do |category|
      test.category_exists?(category).should be_false
    end
    
    test.set_categories(@entry_id,categories)
    
    categories.split(",").each do |category|
      cat = test.category_exists?(category)
      cat.should_not be_false
    end
    
    bob = KalturaFu.client.category_service.list.objects
    bob.each do |cat|
      if cat.name =~/^(waffles|pirates|peanuts)(.*)/
        KalturaFu.client.category_service.delete(cat.id)
      end
    end
      
  end
  
  it "should allow you to add tags onto an existing tag string without knowing the original tags" do
    test = MetadataSpecTester.new
    
    original_tags = test.set_tags(@entry_id,"gorillaz, pop, damon, albarn")
    
    test.add_tags(@entry_id,"mos,def").should == original_tags + ", mos, def"
  end
  
  it "no longer responds to adding a single tag.  dynamic dispatches are cooler than syntax sugar." do
    test = MetadataSpecTester.new
    
    original_tags = test.set_tags(@entry_id,"gorillaz, pop, damon, albarn")
    
    lambda {test.add_tag(@entry_id,"mos")}.should raise_error  
  end
  
  it "should allow you to add admin tags onto an existing tag string without knowing the original tags" do
    test = MetadataSpecTester.new
    
    original_tags = test.set_admin_tags(@entry_id,"gorillaz,pop,damon,albarn")
    
    test.add_admin_tags(@entry_id,"mos,def").should == original_tags + ",mos,def"
  end
  
  it "no longer responds to adding a single admin tag" do
    test = MetadataSpecTester.new
    
    original_tags = test.set_admin_tags(@entry_id,"gorillaz, pop, damon, albarn")
    
    lambda {test.add_admin_tag(@entry_id,"mos")}.should raise_error
  end
  
  it "should let you add categories onto an existing category string as well." do
    test = MetadataSpecTester.new
    
    original_categories = test.set_categories(@entry_id,"peanuts#{rand(10)}")
    
    new_cats = "pirates#{rand(10)},waffles#{rand(10)}"
    test.add_categories(@entry_id,new_cats).should == original_categories + ",#{new_cats}"
    check_string = original_categories + ",#{new_cats}"
    check_string.split(",").each do |category|
      cat = test.category_exists?(category)
      cat.should_not be_false
    end
    bob = KalturaFu.client.category_service.list.objects
    bob.each do |cat|
      if cat.name =~/^(waffles|pirates|peanuts)(.*)/
        KalturaFu.client.category_service.delete(cat.id)
      end
    end
  end
  
  it "should create categories for each one you add if they don't exist." do
    test = MetadataSpecTester.new
    
    original_categories = test.set_categories(@entry_id,"peanuts#{rand(10)}")
    
    new_cats = "pirates#{rand(10)},waffles#{rand(10)}"
    test.add_categories(@entry_id,new_cats)
    check_string = original_categories + ",#{new_cats}"
    check_string.split(",").each do |category|
      cat = test.category_exists?(category)
      cat.should_not be_false
    end
    bob = KalturaFu.client.category_service.list.objects
    bob.each do |cat|
      if cat.name =~/^(waffles|pirates|peanuts)(.*)/
        KalturaFu.client.category_service.delete(cat.id)
      end
    end
  end
  
  it "should no longer respond to adding a single category" do
    test = MetadataSpecTester.new
    
    original_categories = test.set_categories(@entry_id,"peanuts#{rand(10)},pirates#{rand(10)}")
    
    new_cat = "waffles#{rand(10)}"
    lambda{test.add_category(@entry_id,new_cat)}.should raise_error
    
    bob = KalturaFu.client.category_service.list.objects
    bob.each do |cat|
      if cat.name =~/^(waffles|pirates|peanuts)(.*)/
        KalturaFu.client.category_service.delete(cat.id)
      end
    end
  end
  
  it "should let you set multiple fields at once with set()" do
    test = MetadataSpecTester.new
    
    name = "Mr Peanut's wild ride"
    description = "Man this is a random name"
    waffles = "Man waffles isn't an attribute"
    test.set(@entry_id,:name=>name,:description=>description,:waffles=>waffles)
    
    test.get_name(@entry_id).should == name
    test.get_description(@entry_id).should == description
  end
end