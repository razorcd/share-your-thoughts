require 'rails_helper'

RSpec.describe Image, :type => :model do
  describe "image CRUD" do
    before do
      @i = FactoryGirl.build(:image)
    end

    it "save to db" do
      @i.id.should == nil
      @i.save.should == true
      @i.id.should_not == nil
    end

    it "update to db" do
      @i.save.should == true        #save
      i = Image.find(1)             #read
      i.should_not == nil
      i.image_link = "images/image_2.jpg"
      i.save.should == true         #save/update
      Image.find(1).image_link == "images/image_2.jpg"
    end

    it "destroy from db" do
      @i.save.should == true
      i = Image.find(1)
      i.should_not == nil
      i.destroy
      lambda {Image.find(1)}.should raise_error
    end
  end
end
