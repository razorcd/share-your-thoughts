require 'rails_helper'

RSpec.describe User, :type => :model do

  describe "user CRUD" do
    before do
      @u = FactoryGirl.build(:user) 
    end

    after do
      User.all {|u| u.destroy}
      @u = nil
    end

    it "has correct fields" do
      @u.full_name.should == "Full Name"
      @u.username.should == "username"
      @u.password.should == "password"
      @u.password_confirmation.should == "password"
      @u.password_digest.present?.should == true
      @u.authenticate("password").should_not == false
      @u.avatar.should == "/avatarts/username_av1.jpg"
      @u.email.should == "email@ema.il"
    end

    it "save to db" do
      @u.id.should == nil
      @u.save.should_not == false
      @u.id.should_not == nil
    end

    it "read saved to db" do
      @u.save
      User.find(1).username.should == "username"
    end

    it "update to db without new password" do
      @u.save.should == true  #save
      u=User.find(1)
      u.username = "dfsfsdfdf"
      # u.password = "password"
      u.save.should == true
      User.find(1).username.should == "dfsfsdfdf"
    end

    it "not update to db with password but bad _password" do
      @u.save.should == true  #save
      u=User.find(1)
      u.password = "sddfgsdfgdfgdfg"
      u.password_confirmation = "sddfgsdfgdfgdfgsdfsdf___"
      u.username = "dfsfsdfdf111111"
      # u.password = "password"
      u.save.should_not == true
    end
    
    it "destroys from db" do
      @u.save
      @u.id.should > 0
      @u.destroy.should_not == nil
      lambda {User.find(1)}.should  raise_error
    end
  end


  describe "user Validations" do
    before do
      @u = FactoryGirl.build(:user) 
    end

    context "strip  all fields of spaces" do
      before do
        @u_strip = FactoryGirl.build(:user_strip)
      end

      it "stip all fields" do
        @u_strip.full_name.should == "  Full Name  "

        #saving to db
        @u_strip.id.should == nil
        lambda {@u_strip.save}.should_not raise_error
        @u_strip.id.should > 0

        @u_strip.full_name.should == "Full Name"
        @u_strip.username.should == "username"
        @u_strip.email.should == "email@ema.il"
      end
    end

    context "full_name" do
      it "can't be nil or blank or '4356@$^' " do
        @u.full_name = nil
        @u.save.should == false

        @u.full_name = ""
        @u.save.should == false

        @u.full_name = '4356@$^'
        @u.save.should == false
      end

      it "can't be longer than 128 chars" do
        @u.full_name = "1234567890"*13
        @u.full_name.size.should > 128
        @u.save.should == false
      end
    end

    context "username" do
      it "can't be nil or blank or '4356@$^' " do
        @u.username = nil
        @u.save.should == false

        @u.username = ""
        @u.save.should == false

        @u.username = '4356@$^'
        @u.save.should == false
      end

      it "can't be longer than 16 chars" do
        @u.username = "12345678901234567"
        @u.username.size.should > 16
        @u.save.should == false
      end
    end

    context "password" do
      before do
        @u_nopass = FactoryGirl.build(:user_nopassword)
      end

      it "can't be nil or blank  " do
        @u_nopass.password.should == nil
        @u_nopass.password_confirmation.should == nil
        @u_nopass.password_digest.should == nil
        @u_nopass.save.should == false

        @u_nopass.password = ""
        @u_nopass.password_confirmation = ""
        @u_nopass.save.should == false

        @u_nopass.password = '4356@$^'
        @u_nopass.password_confirmation = '4356@$^'
        @u_nopass.save.should == true
      end

      it "can't be longer than 16 chars" do
        @u_nopass.password = "12345678901234567"
        @u_nopass.password_confirmation = "12345678901234567"
        @u_nopass.password.size.should > 16
        @u_nopass.save.should == false
      end

      it "can't be shorter than 6 chars" do
        @u_nopass.password = "12345"
        @u_nopass.password_confirmation = "12345"
        @u_nopass.password.size.should <6
        @u_nopass.save.should == false
      end

      it "works without password_confirmation" do
        @u_nopass.password = "password"
        @u_nopass.password.should == "password"
        @u_nopass.password_digest.should_not == nil
        @u_nopass.save.should == true
      end
    end

    context "email" do
      it "can't be nil or blank or '4356@$^' " do
        @u.email = nil
        @u.save.should == false

        @u.email = ""
        @u.save.should == false

        @u.email = '4356@$^'
        @u.save.should == false

        @u.email = 'email@email.a.b.c.d'
        @u.save.should == false

        @u.email = 'email@ema.il'
        @u.save.should_not == false
      end

      it "can't be longer than 64 chars" do
        @u.email = "1234567890"*6 + "@yahoo.com"
        @u.email.size.should > 64
        @u.save.should == false
      end
    end


  end

end


