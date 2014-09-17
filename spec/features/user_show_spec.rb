require 'rails_helper'

describe "show user page (after login)" do
  
  let(:user) {FactoryGirl.create(:user)}
  
  before do
    visit root_path  #or new_user_path???

    #fill in with correct details and LOGIN
    within '.login_form form' do
      fill_in('user_username', :with => user.username)
      fill_in('user_password', :with => user.password)
      click_button('Login')
    end
  end

  it "should log in and stay logged in" do
    current_path.should == "/users/1/thoughts"
    visit current_path #refresh
    current_path.should == "/users/1/thoughts"
  end

  it "should have 'Please confirm email message'" do
    user.email_confirmed.should == false
    page.body.should have_css(".message")
    find('.message').should have_text('Please confirm your email')
  end

  it "should not have 'Please confirm email message' if already confirmed" do
    user.email_confirmed.should == false
    user.email_confirmed = true
    user.save.should == true #save
    
    visit current_path #refresh page
    current_path.should == "/users/1/thoughts"
    page.body.should_not have_css(".message")  #should not have the .message with 'please confirm email'
  end


  context "Create New Thought Form" do

    it "should exist" do
      page.body.should have_css(".thought_form")
    end

    it "should have correct fields" do
      find(".thought_form").should have_css(".error-message")
      find(".thought_form").should have_field("thought_title")
      find(".thought_form").should have_field("thought_body")
      find(".thought_form").should have_field("thought_shout")
      find(".thought_form").should have_button("Share it")
    end

  end

end



