require "rails_helper"

RSpec.describe UserMailer, :type => :mailer do
  # pending "add some examples to (or delete) #{__FILE__}"
  before do
    @u = FactoryGirl.create(:user) 
  end

  describe "UserMailer" do
    it "should send welcome_email" do
      email = UserMailer.welcome_email(@u).deliver
      ActionMailer::Base.deliveries.count.should == 1   #email delivery confirmed
    end

    it "'welcome_email' should have correct settings" do
      email = UserMailer.welcome_email(@u).deliver #sends email

      email.to.should == [@u.email]
      email.subject.should include('Welcome')
      email.body.encoded.should include(@u.full_name)
      email.body.encoded.should have_link('HERE')
    end
  end
end
