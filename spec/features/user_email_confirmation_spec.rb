  require 'rails_helper'

  describe "Email confirmation mail" do
    before do
      @u = FactoryGirl.create(:user)
    end

    it "should confirm email" do
      email = UserMailer.welcome_email(@u).deliver

      @u.email_confirmed.should == false
      app_url = '/users/confirm_email/' + @u.id.to_s + "?email=" + @u.email 
      
      visit app_url
      
      User.find(@u.id).email_confirmed.should == true   #read user again from DB
      current_path.should == root_path #user_thoughts_path(@u.id)

    end
  end