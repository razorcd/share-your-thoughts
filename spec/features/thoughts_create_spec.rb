require 'rails_helper'


describe "Create Thoughts Form" do
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

  it "should exist" do
    page.body.should have_css(".thought_form")
  end

  context "Validations" do
    before do
      #fill all fields from Create Thoughts form
      within '.thought_form form' do
        fill_in('thought_title', :with => thought.title)
        fill_in('thought_body', :with => thought.body)
        # find(:css,'#thought_shout').set(true)
        check('thought_shout')
      end
    end

    context "Title" do
      it "should not be longer then 64" do
        long_title = "0123456789" * 7
        fill_in('thought_title', :with => long_title)
        click_button('Share it')

        find(".thought_form .error-message").should have_content("Title is too long")
      end

      it "should not be blank" do
        fill_in('thought_title', :with => "")
        click_button('Share it')

        find(".thought_form .error-message").should have_content("Title can't be blank")
      end
    end

    context "Body" do
      it "should not be blank" do
        fill_in('thought_body', :with => "")
        click_button('Share it')

        find(".thought_form .error-message").should have_content("Body can't be blank")
      end
    end

    context "valid fields" do
      it "should pass with valid fields" do
        click_button('Share it')

        current_path.should == "/users/1/thoughts"
        page.body.should have_content(thought.title)   #showing the shared thought
        page.body.should have_content(thought.body)    #showing the shared thought
      end
    end
  end

end

