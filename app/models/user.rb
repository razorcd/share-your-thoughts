class User < ActiveRecord::Base
  has_many :thoughts, :dependent => :destroy
  has_secure_password validations: false
  before_validation :strip_all

  #follow relation
  # has_many :followers_relation, class_name: "Relation", foreign_key: "followee_id"   #or better use trough
  # has_many :followees_relation, class_name: "Relation", foreign_key: "follower_id"   #or better use trough
  has_many :followers_relation, class_name: "Relation", foreign_key: "followee_id"
  has_many :followees_relation, class_name: "Relation", foreign_key: "follower_id"

  has_many :followers, through: :followers_relation
  has_many :followees, through: :followees_relation
  
  # attr_accessor :password, 
  attr_accessor :password_confirmation
  
  validates :full_name, :presence => true,
                        :length => {:within => 2 .. 128},
                        :format => {:with => /\A[a-zA-Z\s\']+\z/i}
  validates :username, :presence => true,
                       :uniqueness => true,
                       :length => {:within => 3 .. 16},
                       :format => {:with => /\A[a-z][a-z0-9_-]+\z/i}
  validate :password, :validate_password
  validates :email, :presence => true,
                    :uniqueness => true,
                    :length => {:within => 2 .. 64},
                    :format => {:with => /\A[_a-zA-Z0-9]([\-+_%.a-zA-Z0-9]+)?@([_+\-%a-zA-Z0-9]+)(\.[a-zA-Z0-9]{0,6}){1,2}([a-zA-Z0-9]\z)/i}


  

  #crear password fields to not send it back to view (security reason)
  def clear_password_fields
      self.password.clear if self.password
      self.password_confirmation.clear if self.password_confirmation
      self.password_digest.clear if self.password_digest
  end

  private 

  def strip_all
    self.full_name = self.full_name.strip if self.full_name
    self.username = self.username.strip if self.username
    self.email = self.email.strip if self.email
  end

  #this password validation passes if there is a password_digest and no password was set. So you can update the fields without adding the password again.
  #password_confirmation does validation only if it is present or not nil
  def validate_password
    if self.password_digest && !self.password 
      return true 
    else
      if self.password.blank? 
        errors.add(:password, "can't be blank") 
      else
        if self.password.size < 6 then errors.add(:password, "is too short (minimum is 6 characters)") end
        if self.password.size > 16 then errors.add(:password, "is too long (maximum is 16 characters)") end
        if (defined? self.password_confirmation)  &&  (self.password_confirmation != nil)  &&  (self.password != self.password_confirmation) then errors.add(:password, "does not match the password confirmation") end
      end
    end
  end

end
