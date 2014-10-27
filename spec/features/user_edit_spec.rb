require 'rails_helper'

describe "user edit page" do

  describe "Edit your details" do
    let(:user) {FactoryGirl.create(:user)}

    before do
      visit root_path  #or new_user_path???

      #fill in with correct details
      within '.login_form form' do
        fill_in('user_username', :with => user.username)
        fill_in('user_password', :with => user.password)
      end
      #LOGIN
      click_button("Login")

      visit edit_user_path(:id => user.id)
    end

    it "should have 'Edit yout details' form" do
      current_path.should == "/users/1/edit"
      page.body.should have_css('.user_form')

      first('.user_form').find_field('user[full_name]').value.should == user.full_name
      first('.user_form').find_field('user[username]').value.should == user.username
      first('.user_form').find_field('user[email]').value.should == user.email
      first('.user_form').find_field('user[password]').value.should == nil #""
      first('.user_form').should have_button('Save')
    end

    it "should update User" do
      current_path.should == "/users/1/edit"
      first('.user_form').fill_in('user[full_name]', :with => "NewFullName")
      first('.user_form').fill_in('user[username]', :with => "username222")
      first('.user_form').fill_in('user[email]', :with => "email222@ema.il")
      first('.user_form').fill_in('user[password]', :with => "password")
      click_button('Save')
      
      current_path.should == "/users/1"  #should redirect to same address
      first('.user_form').find_field('user[full_name]').value.should == "NewFullName"
      first('.user_form').find_field('user[username]').value.should == "username222"
      first('.user_form').find_field('user[email]').value.should == "email222@ema.il"
      first('.user_form').find_field('user[password]').value.should == nil #""
    end

    it "should not send email confirmation if email wasn't changed" do
      ActionMailer::Base.deliveries = []
      current_path.should == "/users/1/edit"
      first('.user_form').fill_in('user[full_name]', :with => "NewFullName")
      first('.user_form').fill_in('user[username]', :with => "username222")
      # first('.user_form').fill_in('user[email]', :with => "email222@ema.il")
      first('.user_form').fill_in('user[password]', :with => "password")
      click_button('Save')

      ActionMailer::Base.deliveries.count.should == 0      
    end

    it "should update email and send new 'Email confirmation' email on email change" do
      ActionMailer::Base.deliveries = []
      current_path.should == "/users/1/edit"
      first('.user_form').fill_in('user[email]', :with => "email222@ema.il")
      first('.user_form').fill_in('user[password]', :with => "password")
      click_button('Save')

      ActionMailer::Base.deliveries.count.should == 1
      ActionMailer::Base.deliveries[0].body.encoded.should match('users/confirm_email')
      # page.body.should have_content('Confirmation email sent')   #should get a 'Confirmation email sent' message
    end

    it "should set 'user.email_confirmed' to false if email si updated" do
      #set user.email_confirmed = true
      u = User.find(1)
      u.email_confirmed = true
      u.save

      User.find(1).email_confirmed.should == true  #check user.email_confirmed == true
      current_path.should == "/users/1/edit"
      first('.user_form').fill_in('user[email]', :with => "email222@ema.il")
      first('.user_form').fill_in('user[password]', :with => "password")
      click_button('Save')

      User.find(1).email_confirmed.should == false #check user.email_confirmed == false  after email change
    end



    it "should give wrong password errors" do
      current_path.should == "/users/1/edit"
      first('.user_form').fill_in('user[full_name]', :with => "NewFullName")
      first('.user_form').fill_in('user[username]', :with => "username222")
      first('.user_form').fill_in('user[email]', :with => "email222@ema.il")
      first('.user_form').fill_in('user[password]', :with => "fsf")
      click_button('Save')
      
      current_path.should == "/users/1"  #should redirect to same address
      first('.user_form').find('.error-message').should have_content("Password is wrong")
      first('.user_form').find_field('user[full_name]').value.should == "NewFullName"
      first('.user_form').find_field('user[username]').value.should == "username222"
      first('.user_form').find_field('user[email]').value.should == "email222@ema.il"
      first('.user_form').find_field('user[password]').value.should == nil #""
    end

    it "should give validation errors errors" do
      current_path.should == "/users/1/edit"
      first('.user_form').fill_in('user[full_name]', :with => "")
      first('.user_form').fill_in('user[username]', :with => "")
      first('.user_form').fill_in('user[email]', :with => "")
      first('.user_form').fill_in('user[password]', :with => "password")
      click_button('Save')
      
      current_path.should == "/users/1"  #should redirect to same address
      first('.user_form').find('.error-message').should have_content("Full name can't be blank")
      first('.user_form').find('.error-message').should have_content("Username is invalid")
      first('.user_form').find('.error-message').should have_content("Email is invalid")
    end
  end

  describe "Resend email confirmation" do
    let(:user) {FactoryGirl.create(:user)}

    before do
      visit root_path  #or new_user_path???

      #fill in with correct details
      within '.login_form form' do
        fill_in('user_username', :with => user.username)
        fill_in('user_password', :with => user.password)
      end
      #LOGIN
      click_button("Login")

      visit edit_user_path(:id => user.id)
    end   

    it "should have Reset email confirmation button" do
      page.should have_content('Resend email confirmation')
      page.should have_link('Resend')
    end

    it "Resend link should send email" do
      ActionMailer::Base.deliveries = []
      click_link('Resend')
      ActionMailer::Base.deliveries.count.should == 1
      ActionMailer::Base.deliveries[0].body.encoded.should match('users/confirm_email')
      page.body.should have_content('Confirmation email sent')   #should get a 'Confirmation email sent' message
    end

  end

  describe "Change your password" do

    let(:user) {FactoryGirl.create(:user)}

    before do
      visit root_path  #or new_user_path???

      #fill in with correct details
      within '.login_form form' do
        fill_in('user_username', :with => user.username)
        fill_in('user_password', :with => user.password)
      end
      #LOGIN
      click_button("Login")

      visit edit_user_path(:id => user.id)
    end


    it "should change password on correct fields" do
      current_path.should == "/users/1/edit"
      page.find('#change_password').fill_in('user[old_password]', :with => "password")
      page.find('#change_password').fill_in('user[password]', :with => "password1")
      page.find('#change_password').fill_in('user[password_confirmation]', :with => "password1")
      page.find('#change_password').click_button("Reset")

      current_path.should == "/users/1/edit"
      page.first('.message').should have_content('Password changed')
      user = User.find(1)
      user.authenticate('password1').should_not == false   #password was changed
      user.authenticate('password').should == false
    end

    it "should not change password on incorrect old password" do
      current_path.should == "/users/1/edit"
      page.find('#change_password').fill_in('user[old_password]', :with => "wrong_password")
      page.find('#change_password').fill_in('user[password]', :with => "password1")
      page.find('#change_password').fill_in('user[password_confirmation]', :with => "password1")
      page.find('#change_password').click_button("Reset")

      current_path.should == "/users/1/edit"
      page.find('#change_password').find('.error-message').should have_content('Wrong old password')
      user.authenticate('password').should_not == false   #password was not changed
    end

    it "should not change password on empty new password" do
      current_path.should == "/users/1/edit"
      page.find('#change_password').fill_in('user[old_password]', :with => "password")
      page.find('#change_password').fill_in('user[password]', :with => "")
      page.find('#change_password').fill_in('user[password_confirmation]', :with => "")
      page.find('#change_password').click_button("Reset")

      current_path.should == "/users/1/edit"
      page.find('#change_password').find('.error-message').should have_content('Enter new password and confirmation')
      user.authenticate('password').should_not == false   #password was not changed
    end    


    it "should not change password on  new password != password confirmation" do
      current_path.should == "/users/1/edit"
      page.find('#change_password').fill_in('user[old_password]', :with => "password")
      page.find('#change_password').fill_in('user[password]', :with => "qwerty")
      page.find('#change_password').fill_in('user[password_confirmation]', :with => "sdfgdfhg")
      page.find('#change_password').click_button("Reset")

      current_path.should == "/users/1/edit"
      page.find('#change_password').find('.error-message').should have_content('Password does not match')
      user.authenticate('password').should_not == false   #password was not changed
    end 

    it "should not change password on  invalid new pasword" do
      current_path.should == "/users/1/edit"
      page.find('#change_password').fill_in('user[old_password]', :with => "password")
      page.find('#change_password').fill_in('user[password]', :with => "123")
      page.find('#change_password').fill_in('user[password_confirmation]', :with => "123")
      page.find('#change_password').click_button("Reset")

      current_path.should == "/users/1/edit"
      page.find('#change_password').find('.error-message').should have_content('Password is too short')
      user.authenticate('password').should_not == false   #password was not changed
    end 
  end


end