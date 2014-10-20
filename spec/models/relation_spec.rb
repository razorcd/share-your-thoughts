require 'rails_helper'

RSpec.describe Relation, :type => :model do
  describe "Relation" do
    before do
      @u = FactoryGirl.create(:user) 
      @u2 = FactoryGirl.create(:user2) 

      # @u follows @u2
      rel = Relation.new
      rel.follower_id = @u.id
      rel.followee_id = @u2.id
      rel.save
    end

    it "should exist in db" do
      Relation.all.size.should > 0
    end

    it "should be accessible from users.followees" do
      @u.followees.size.should > 0        # @u followes one user
      @u.followees[0].username.should == @u2.username # @u followes @u2
      @u.followers.size.should == 0    #nobody follows @u
    end

    it "should be accessible from user.followers" do
      @u2.followers.size > 0  # @u2 is followed by one user
      @u2.followers[0].username.should == @u.username # @u2 is followed by @u
      @u2.followees.size.should == 0  #@u2 doesen't follow anybody
    end

  end
end