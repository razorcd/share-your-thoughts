require 'rails_helper'


describe "fill Register Form" do
  let(:user) {FactoryGirl.build(:user)}
  # subject {user}
  before do 
    visit root_path  #or new_user_path???

    #fill in with correct details
    within '.register_form form' do
      fill_in('user_full_name', :with => user.full_name)
      fill_in('user_username', :with => user.username)
      fill_in('user_password', :with => user.password)
      fill_in('user_password_confirmation', :with => user.password_confirmation)
      fill_in('user_email', :with => user.email)
    end
  end

  context "wrong full_name" do
    it "should fail if full_name is blank" do
      page.body.should have_button("Register")
      find('.register_form form').fill_in('user_full_name', :with => "")
      click_button('Register')

      current_path.should == root_path
      find(".register_form .error-message").should have_content("Full name can't be blank")
    end

    it "should fail if full_name is too long" do
      page.body.should have_button("Register")
      long_name = "asdfghjklz"*13
      find('.register_form form').fill_in('user_full_name', :with => long_name)
      click_button('Register')

      current_path.should == root_path
      find(".register_form .error-message").should have_content("Full name is too long")
    end

    it "should fail if full_name is 'djfg874jf0_&s'" do
      page.body.should have_button("Register")
      find('.register_form form').fill_in('user_full_name', :with => "djfg874jf0_&s")
      click_button('Register')

      current_path.should == root_path
      find(".register_form .error-message").should have_content("Full name is invalid")
    end
  end

  context "wrong username" do
    it "should fail if username is blank" do
      page.body.should have_button("Register")
      find('.register_form form').fill_in('user_username', :with => "")
      click_button('Register')

      current_path.should == root_path
      find(".register_form .error-message").should have_content("Username can't be blank")
    end

    it "should fail if username is too short" do
      page.body.should have_button("Register")
      find('.register_form form').fill_in('user_username', :with => "ab")
      click_button('Register')

      current_path.should == root_path
      find(".register_form .error-message").should have_content("Username is too short")
    end

    it "should fail if username is too long" do
      page.body.should have_button("Register")
      long_username = 'qwertyuiop'*7
      find('.register_form form').fill_in('user_username', :with => long_username)
      click_button('Register')

      current_path.should == root_path
      find(".register_form .error-message").should have_content("Username is too long")
    end

    it "should fail if username is 'fdgdf34ter6%^%$'" do
      page.body.should have_button("Register")
      find('.register_form form').fill_in('user_username', :with => "fdgdf34ter6%^%$")
      click_button('Register')

      current_path.should == root_path
      find(".register_form .error-message").should have_content("Username is invalid")
    end
  end

  context "wrong password and password_confirmation" do
    it "should fail if password is blank" do
      page.body.should have_button("Register")
      find('.register_form form').fill_in('user_password', :with => "")
      click_button('Register')

      current_path.should == root_path
      find(".register_form .error-message").should have_content("Password can't be blank")
    end

    it "should fail if password is too short" do
      page.body.should have_button("Register")
      find('.register_form form').fill_in('user_password', :with => "abcde")
      click_button('Register')

      current_path.should == root_path
      find(".register_form .error-message").should have_content("Password is too short")
    end

    it "should fail if password is too long" do
      page.body.should have_button("Register")
      long_pass= "a"*17
      find('.register_form form').fill_in('user_password', :with => long_pass)
      click_button('Register')

      current_path.should == root_path
      find(".register_form .error-message").should have_content("Password is too long")
    end

    it "should fail if password is different than password confirmation" do
      page.body.should have_button("Register")
      find('.register_form form').fill_in('user_password', :with => "abcdefghi")
      find('.register_form form').fill_in('user_password_confirmation', :with => "")
      click_button('Register')

      current_path.should == root_path
      find(".register_form .error-message").should have_content("Password does not match the password confirmation")
    end
  end

  context "wrong email" do
    it "should fail if email is blank" do
      page.body.should have_button("Register")
      find('.register_form form').fill_in('user_email', :with => "")
      click_button('Register')

      current_path.should == root_path
      find(".register_form .error-message").should have_content("Email can't be blank")
    end

    it "should fail if email is too long" do
      page.body.should have_button("Register")
      long_email = "abcdefgdfh"*6 + "@gmail.com"
      find('.register_form form').fill_in('user_email', :with => long_email)
      click_button('Register')

      current_path.should == root_path
      find(".register_form .error-message").should have_content("Email is too long")
    end

    it "should fail if email is invalid" do
      page.body.should have_button("Register")
      find('.register_form form').fill_in('user_email', :with => "gdfg@dfgdf342.23423.423.434")
      click_button('Register')

      current_path.should == root_path
      find(".register_form .error-message").should have_content("Email is invalid")
    end
  end

  context "valid fields" do
    before do
      #register with valid fields first
      page.body.should have_button("Register")
      click_button('Register')      
    end

    it "should create a new user in DB" do
      lambda {User.find(1)}.should_not raise_error
      @user = User.find(1)
      @user.username.should == "username"
    end

    it "should render show view" do
      current_path.should == "/users/1/thoughts"
    end

    it "should be Logged In after registering" do
      visit "/users/1/thoughts"
      current_path.should == "/users/1/thoughts"
    end

    context "username, email already exists in DB" do
      #logout and go to root_url
      before do
        visit "/users/logout"

        #fill in with correct details
        within '.register_form form' do
          fill_in('user_full_name', :with => user.full_name)
          fill_in('user_username', :with => user.username)
          fill_in('user_password', :with => user.password)
          fill_in('user_password_confirmation', :with => user.password_confirmation)
          fill_in('user_email', :with => user.email)
        end
      end

      it "should give a User already exists error when trying to register with existing username" do
        page.body.should have_button('Register')
        click_button('Register')

        current_path.should == root_path #"/users" #rooth path redirect here
        find(".register_form .error-message").should have_content("Username has already been taken")
        find(".register_form .error-message").should have_content("Email has already been taken")
      end
    end
  end

end


