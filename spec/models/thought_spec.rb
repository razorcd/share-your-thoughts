require 'rails_helper'

RSpec.describe User, :type => :model do


  describe "thoughts CRUD" do
    before do
      @t = FactoryGirl.build(:thought) 
    end

    it "has correct fields" do
      @t.title.should == "Thought 1"
      @t.body.should == "Body thought 1"
      @t.shout?.should == false
      # @t.user_id.should_not == nil
    end

    it "save to db" do
      @t.id.should == nil
      @t.save.should_not == false
      @t.id.should_not == nil
    end

    it "read the saved to db" do
      @t.save.should == true  #save
      Thought.find(1).title.should == "Thought 1"
    end

    it "update to db" do
      @t.save.should == true  #save
      t=Thought.find(1)
      t.title = "Thought 2"
      t.save.should == true
      Thought.find(1).title.should == "Thought 2"
    end

    it "destroys from db" do
      @t.save
      @t.id.should > 0
      @t.destroy.should_not == nil
      lambda {Thought.find(1)}.should  raise_error
    end
  end

  describe "thoughts Validations" do

    before do
      @t = FactoryGirl.build(:thought) 
    end

    context "strip  all fields of spaces" do
      before do
        @t_strip = FactoryGirl.build(:thought_strip)
      end

      it "stip all fields" do
        @t_strip.title.should == "  AAAA  "

        #saving to db
        @t_strip.id.should == nil
        lambda {@t_strip.save}.should_not raise_error
        @t_strip.id.should > 0

        @t_strip.title.should == "AAAA"
        @t_strip.body.should == "Body"
      end
    end

    context "title" do
      it "can't be nil or blank " do
        @t.title = nil
        @t.save.should == false

        @t.title = ""
        @t.save.should == false
      end

      it "can't be longer than 64 chars" do
        @t.title = "1234567890"*7
        @t.title.size.should > 64
        @t.save.should == false
      end
    end

    context "body" do
      it "can't be nil or blank " do
        @t.body = nil
        @t.save.should == false

        @t.body = ""
        @t.save.should == false
      end

      # it "can't be longer than 64 chars" do
      #   @t.title = "1234567890"*7
      #   @t.title.size.should > 64
      #   @t.save.should == false
      # end
    end
  end

  describe "thoughts with images" do
    before do
      @u = FactoryGirl.build(:user)          
      @t = FactoryGirl.build(:thought) 
      @i = FactoryGirl.build(:image)
      # @u.thoughts << @t
    end

    it "have images method" do
      @t.images.should.class == Array
      @t.images.size.should == 0
    end

    it "add new images" do
      @t.images << @i
      @t.images.size.should == 1
    end

    it "save/read images to db" do
      @t.images << @i
      @t.save.should == true
      Thought.find(1).images.size.should == 1
    end

    it "accept multiple images" do 
      @t.images << @i
      @t.images << Image.new(:image_link => "image2.jpg")
      @t.images << Image.new(:image_link => "image3.jpg")
      @t.save.should == true     # saves 'thought' all images too
      Thought.find(1).images.size.should == 3
    end

    it "destroys all related images on thought destroy" do
      @t.images << @i
      @t.save.should == true
      Image.all.size.should > 0 # there should be an image in 'images' table
      Thought.find(1).destroy   # destroing te only thought record
      Image.all.size.should == 0 # image recod should be destroyed too
    end

  end



end