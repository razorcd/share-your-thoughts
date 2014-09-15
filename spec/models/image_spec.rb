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

  describe "image Validation" do
    before do
      @i = FactoryGirl.build(:image)
    end

    context "image_link" do
      it "can't be blank " do
        @i.image_link = nil
        @i.image_link.should == nil
        @i.save.should == false
      end

      it "can't be '' " do
        @i.image_link = ''
        @i.image_link.should == ''
        @i.save.should == false
      end
      it "can't be longer then 128" do
        @i.image_link = "1234567890" * 13
        @i.image_link.size.should > 128
        @i.save.should == false
      end
    end
  end
end
