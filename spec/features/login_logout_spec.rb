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

      current_path.should be == "/users/1/thoughts"
      page.body.should have_link('Logout')
    end

    # it "should redirect from root to user_path" do 
    #   #logging in
    #   page.body.should have_button('Login')
    #   click_button('Login')

    #   visit root_path
    #   current_path.should be == "/users/1/thoughts"
    # end

    it "should redirect if trying to access other users page" do
      #logging in
      page.body.should have_button('Login')
      click_button('Login')

      visit "/users/3/thoughts"
      current_path.should be == "/users/1/thoughts"
    end

  end

  context "wrong username/password" do
    it "should not login" do
      page.body.should have_button('Login')
      find('.login_form form').fill_in('user_username', :with => "dfg")
      click_button('Login')

      current_path.should be == "/"
      find(".login_form .error-message").should have_content("Wrong username/password")
    end

    it "should not login" do
      page.body.should have_button('Login')
      find('.login_form form').fill_in('user_password', :with => "dfg")
      click_button('Login')

      current_path.should be == "/"
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
      current_path.should be == "/users/1/thoughts"   #should be logged in
      visit "/users/1/thoughts"                    #visiting restricted access page
      current_path.should be == "/users/1/thoughts"   #should stay logged in
      visit "/users/logout"                        #loggin out
      current_path.should be == "/"                   #should redirect to path
      visit "/users/1/thoughts"                    #visiting restricted access page
      current_path.should be == "/"                   #should redirect to path when not logged in
    end

    it "should logout clicking Logout button"  do
      page.body.should have_link('Logout')
      current_path.should be == "/users/1/thoughts"   #should be logged in
      visit "/users/1/thoughts"                    #visiting restricted access page
      current_path.should be == "/users/1/thoughts"   #should stay logged in
      click_link('Logout')                         #loggin out
      current_path.should be == "/"                   #should redirect to path
      visit "/users/1/thoughts"                    #visiting restricted access page
      current_path.should be == "/"                   #should redirect to path when not logged in
    end
  end

end