require 'rails_helper'


describe "Thoughts List" do
  let(:user) {FactoryGirl.create(:user)}
  let(:thought) {FactoryGirl.build(:thought)}

  before do
    visit root_path  #or new_user_path???

    #fill in with correct details and LOGIN
    within '.login_form form' do
      fill_in('user_username', :with => user.username)
      fill_in('user_password', :with => user.password)
      click_button('Login')
    end

  end

  context "No thoughts present for current user" do
    it "User should have no thoughts" do
      User.find(1).thoughts.size.should == 0
    end
    it "should not show the Thoughts List" do
      page.body.should_not have_css(".thoughts_list")
    end
  end

  context "1 thought present for current user" do
    before do
      user.thoughts << thought
      visit "/users/1/thoughts"
    end

    it "User should have a thought" do
      User.find(1).thoughts.size.should == 1
    end

    it "should be visible" do
      current_path.should == "/users/1/thoughts"
      page.body.should have_css(".thoughts_list")
    end

    it "should have correct thought fields" do
      find(".thoughts_list .thought-item").find(".title").should have_text(thought.title)
      find(".thoughts_list .thought-item").find(".body").should have_text(thought.body)
      find(".thoughts_list .thought-item").find(".name-time").should have_text(thought.created_at.strftime("%Y-%m-%d"))
    end


  end
end