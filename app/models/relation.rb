class Relation < ActiveRecord::Base
  belongs_to :follower, class_name:"User"
  belongs_to :followee, class_name: "User"

  # validate :follower, :presence => true
  # validate :followee, :presence => true
end
