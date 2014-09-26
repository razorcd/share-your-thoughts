require 'rails_helper'


describe "GET root" do
  before do
    visit root_path
  end

  # it {response.should render_template(:index)}
  it "should give a 200 HTTP response" do
    page.status_code.should == 200
    page.body.should have_css(".register_form form")
  end

  it "should have header" do
    page.body.should have_css("header .title")
  end

  it "should have footer" do
    page.body.should have_css("footer")
  end

  it "should have login form" do
    page.body.should have_button("Login")
    all(:css, '.login_form form')[0].should have_field("user_username")
    all(:css, '.login_form form')[0].should have_field("user_password")
    all(:css, '.login_form form')[0].should have_button('Login')
  end

  it "should have register form" do
    page.body.should have_button("Register")
    all(:css, '.register_form form')[0].should have_field("user_full_name")
    all(:css, '.register_form form')[0].should have_field("user_username")
    all(:css, '.register_form form')[0].should have_field("user_password")
    all(:css, '.register_form form')[0].should have_field("user_password_confirmation")
    all(:css, '.register_form form')[0].should have_field("user_email")
    all(:css, '.register_form form')[0].should have_button('Register')
  end

  context "list of all thoughts" do

    context "with thoughts in DB" do
        let(:user) {FactoryGirl.create(:user)}
        let(:thought) {FactoryGirl.create(:thought)}

        before do
          #to create user and thought in DB:
          user
          thought

          visit root_path
        end

        it "should exist" do
          current_path.should == "/"
          page.body.should have_css(".thoughts_list")
          find(".thoughts_list .thought-item").find(".title").should have_text(thought.title)
          find(".thoughts_list .thought-item").find(".body").should have_text(thought.body)
          find(".thoughts_list .thought-item").find(".name-time").should have_text(thought.user.full_name)
        end
    end

    context "without thoughts in DB" do
      before do
        visit root_path
      end

      it "should not exist" do
        current_path.should == "/"
        page.body.should_not have_css(".thoughts_list")
      end
    end
  end


end

