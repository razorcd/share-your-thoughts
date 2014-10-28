require 'rails_helper'

describe "forgot_password form" do
  before do
    visit forgot_password_users_path
  end

  it "should have correct fields" do
    current_path.should == '/users/forgot_password'
    page.should have_content('Reset your password')
    find('.user_form').should have_field('user[email]')
    find('.user_form').should have_button('Send')
  end

  it "should give error on invalid email" do
    fill_in('user[email]', :with => 'asfasfasf')
    click_button('Send')

    current_path.should == '/users/forgot_password'
    find('.user_form').find('.error-message').should have_content('Invalid email')
  end

  it "should give error on empty email" do
    # fill_in('user[email]', :with => '')
    click_button('Send')

    current_path.should == '/users/forgot_password'
    find('.user_form').find('.error-message').should have_content('Invalid email')
  end

  it "should give error on email that is not in DB" do
    fill_in('user[email]', :with => 'aaa@aaa.aaa')
    click_button('Send')

    current_path.should == '/users/forgot_password'
    find('.user_form').find('.error-message').should have_content("Can't find email in db")
  end

  it "should reset password for a valid users email" do
    ActionMailer::Base.deliveries = []  #deletes all past emails
    u = FactoryGirl.create(:user)
    oldpass_digest = u.password_digest
    fill_in('user[email]', :with => u.email)
    click_button('Send')

    current_path.should == root_path
    find('.message').should have_content("Password was reset")
    ActionMailer::Base.deliveries.count.should == 1
    User.find(1).password_digest.should_not == oldpass_digest
  end

end