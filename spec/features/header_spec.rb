require 'rails_helper'

describe "header" do
  before do
    visit root_path
  end
  context "LOGGED OUT" do
    it "should have only title" do
      find('header').find(".title").should have_content("Share your thoughts")
    end
  end


  context "LOGGED IN" do
    let(:user){FactoryGirl.create(:user)}

    before do
      visit root_path
      #fill Login Form with correct details
      within '.login_form form' do
        fill_in('user_username', :with => user.username)
        fill_in('user_password', :with => user.password)
      end
      click_button('Login')
    end

    it "should have user,edit and logout buttons" do
      current_path.should == "/users/1/thoughts"
      find('header').find(".user-info").should have_link(user.username)
      find('header').find(".user-info").should have_link('edit')
      find('header').find(".user-info").should have_link("Logout")
    end
  end
end