require 'rails_helper'

#testing LOGIN form from root path
describe "fill Register Form" do
  let(:user) {FactoryGirl.create(:user)}
  # subject {user}
  before do 
    visit root_path  #or new_user_path???

    #fill in with correct details
    within '.login_form form' do
      fill_in('user_username', :with => user.username)
      fill_in('user_password', :with => user.password)
    end
  end

  context "good username/password" do
    it "should login"  do
      page.body.should have_button('Login')
      click_button('Login')

      current_path.should == "/users/1"
      page.body.should have_link('Logout')
    end
  end

  context "wrong username/password" do
    it "should not login" do
      page.body.should have_button('Login')
      find('.login_form form').fill_in('user_username', :with => "dfg")
      click_button('Login')

      current_path.should == "/"
      find(".login_form .error-message").should have_content("Wrong username/password")
    end

    it "should not login" do
      page.body.should have_button('Login')
      find('.login_form form').fill_in('user_password', :with => "dfg")
      click_button('Login')

      current_path.should == "/"
      find(".login_form .error-message").should have_content("Wrong username/password")
    end
  end

  context "logout" do
    #login first
    before do
      page.body.should have_button('Login')
      click_button('Login')
    end
    it "should logout visiting '/users/logout' path"  do
      current_path.should == "/users/1"   #should be logged in
      visit "/users/1"                    #visiting restricted access page
      current_path.should == "/users/1"   #should stay logged in
      visit "/users/logout"               #loggin out
      current_path.should == "/"          #should redirect to path
      visit "/users/1"                    #visiting restricted access page
      current_path.should == "/"          #should redirect to path when not logged in
    end

    it "should logout clicking Logout button"  do
      page.body.should have_link('Logout')
      current_path.should == "/users/1"   #should be logged in
      visit "/users/1"                    #visiting restricted access page
      current_path.should == "/users/1"   #should stay logged in
      click_link('Logout')               #loggin out
      current_path.should == "/"          #should redirect to path
      visit "/users/1"                    #visiting restricted access page
      current_path.should == "/"          #should redirect to path when not logged in
    end
  end

end