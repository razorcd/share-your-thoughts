require 'rails_helper'

describe "user list page (user#index)" do
  let(:user){FactoryGirl.create(:user)}
  let(:user2){FactoryGirl.create(:user2)}
  before do
    #creating users in DB:
    user
    user2

    visit users_url
  end

  it "should have a list of users" do
    page.body.should have_css(".thoughts_list")
    find('.thoughts_list').should have_content(user.full_name)
    find('.thoughts_list').should have_content(user2.full_name)
  end
  
end