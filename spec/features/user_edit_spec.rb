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
    click_button("Login")
    visit user_path(:id => user.id)
  end

  it "should have 'Edit yout details' form" do
    current_path.should == "/users/1"
    page.body.should have_css('.user_form')

    find('.user_form').find_field('user[full_name]').value.should == user.full_name
    find('.user_form').find_field('user[username]').value.should == user.username
    find('.user_form').find_field('user[email]').value.should == user.email
    find('.user_form').find_field('user[password]').value.should == nil #""
    find('.user_form').should have_button('Save')
  end
end