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

  context "Follow/Unfollow" do
      before do
        # user follows user2
        rel = Relation.new
        rel.follower_id = user.id
        rel.followee_id = user2.id
        rel.save

        visit users_url
      end

      context "Not Logged-in" do
        it "should not have follow or unfollow button" do

          find('.thoughts_list').should_not have_link('Follow')
          find('.thoughts_list').should_not have_link('Unfollow')
        end
      end

      context "Logged-in" do
        before do
          visit root_path  #or new_user_path???

          #fill in with correct details
          within '.login_form form' do
            fill_in('user_username', :with => user.username)
            fill_in('user_password', :with => user.password)
          end
          #LOGIN
          click_button("Login")

          visit users_url
        end

        it "should have follow or unfollow button" do
          page.body.should have_link('Unfollow')
          first('.thought-item').should_not have_link('Follow')
          first('.thought-item').should_not have_link('Unfollow')

          all('.thought-item').last.should_not have_link('Follow')
          all('.thought-item').last.should have_link('Unfollow')
        end

        it "Unfollow and Follow links should work" do
          #click Unfollow
          all('.thought-item').last.click_link('Unfollow')
          all('.thought-item').last.should have_link('Follow')
          all('.thought-item').last.should_not have_link('Unfollow')

          #click Follow
          all('.thought-item').last.click_link('Follow')
          all('.thought-item').last.should_not have_link('Follow')
          all('.thought-item').last.should have_link('Unfollow')
        end

        it "Following and Followed couters should work" do
          first('.thought-item').should have_content("Following: 1")
          first('.thought-item').should have_content("Followed by: 0")
          all('.thought-item').last.should have_content("Following: 0")
          all('.thought-item').last.should have_content("Followed by: 1")

          #click Unfollow
          all('.thought-item').last.click_link('Unfollow')
          first('.thought-item').should have_content("Following: 0")
          first('.thought-item').should have_content("Followed by: 0")
          all('.thought-item').last.should have_content("Following: 0")
          all('.thought-item').last.should have_content("Followed by: 0")

          #click Follow
          all('.thought-item').last.click_link('Follow')
          first('.thought-item').should have_content("Following: 1")
          first('.thought-item').should have_content("Followed by: 0")
          all('.thought-item').last.should have_content("Following: 0")
          all('.thought-item').last.should have_content("Followed by: 1")
        end

      end


  end
  
end