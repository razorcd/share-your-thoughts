require 'rails_helper'

describe "user edit page" do
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

    find('.user_form').find_field('user[full_name]').value.should == user.full_name
    find('.user_form').find_field('user[username]').value.should == user.username
    find('.user_form').find_field('user[email]').value.should == user.email
    find('.user_form').find_field('user[password]').value.should == nil #""
    find('.user_form').should have_button('Save')
  end

  it "should update User" do
    current_path.should == "/users/1/edit"
    find('.user_form').fill_in('user[full_name]', :with => "NewFullName")
    find('.user_form').fill_in('user[username]', :with => "username222")
    find('.user_form').fill_in('user[email]', :with => "email222@ema.il")
    find('.user_form').fill_in('user[password]', :with => "password")
    click_button('Save')
    
    current_path.should == "/users/1"  #should redirect to same address
    find('.user_form').find_field('user[full_name]').value.should == "NewFullName"
    find('.user_form').find_field('user[username]').value.should == "username222"
    find('.user_form').find_field('user[email]').value.should == "email222@ema.il"
    find('.user_form').find_field('user[password]').value.should == nil #""
  end

  it "should give wrong password errors" do
    current_path.should == "/users/1/edit"
    find('.user_form').fill_in('user[full_name]', :with => "NewFullName")
    find('.user_form').fill_in('user[username]', :with => "username222")
    find('.user_form').fill_in('user[email]', :with => "email222@ema.il")
    find('.user_form').fill_in('user[password]', :with => "fsf")
    click_button('Save')
    
    current_path.should == "/users/1"  #should redirect to same address
    find('.user_form').find('.error-message').should have_content("Password is wrong")
    find('.user_form').find_field('user[full_name]').value.should == "NewFullName"
    find('.user_form').find_field('user[username]').value.should == "username222"
    find('.user_form').find_field('user[email]').value.should == "email222@ema.il"
    find('.user_form').find_field('user[password]').value.should == nil #""
  end

  it "should give validation errors errors" do
    current_path.should == "/users/1/edit"
    find('.user_form').fill_in('user[full_name]', :with => "")
    find('.user_form').fill_in('user[username]', :with => "")
    find('.user_form').fill_in('user[email]', :with => "")
    find('.user_form').fill_in('user[password]', :with => "password")
    click_button('Save')
    
    current_path.should == "/users/1"  #should redirect to same address
    find('.user_form').find('.error-message').should have_content("Full name can't be blank")
    find('.user_form').find('.error-message').should have_content("Username is invalid")
    find('.user_form').find('.error-message').should have_content("Email is invalid")
  end
end